import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleCommandService {
  // Constantes para evitar números mágicos
  static const int PACKET_LENGTH = 20;

  // UUIDs de servicio y características
  final Uuid serviceUuid =
  Uuid.parse("49535343-FE7D-4AE5-8FA9-9FAFD205E455");
  final Uuid rxCharacteristicUuid =
  Uuid.parse("49535343-8841-43F4-A8D4-ECBE34729BB4");
  final Uuid txCharacteristicUuid =
  Uuid.parse("49535343-1E4D-4BD9-BA61-23C647249617");

  // Códigos de comando (constantes)
  static const int FUN_INIT = 0x00;
  static const int FUN_INIT_R = 0x01;
  static const int FUN_INFO = 0x02;
  static const int FUN_INFO_R = 0x03;
  static const int FUN_GET_NAMEBT = 0x04;
  static const int FUN_GET_NAMEBT_R = 0x05;
  static const int FUN_GET_PARAMBAT = 0x08;
  static const int FUN_GET_PARAMBAT_R = 0x09;
  static const int FUN_GET_CONTADOR = 0x0C;
  static const int FUN_GET_CONTADOR_R = 0x0D;
  static const int FUN_SET_CONTADOR = 0x0E;  // 14 en decimal
  static const int FUN_SET_CONTADOR_R = 0x0F; // 15 en decimal
  static const int FUN_GET_ESTADO_EMS = 0x10;
  static const int FUN_GET_ESTADO_EMS_R = 0x11;
  static const int FUN_RUN_EMS = 0x12;
  static const int FUN_RUN_EMS_R = 0x13;
  static const int FUN_STOP_EMS = 0x14;
  static const int FUN_STOP_EMS_R = 0x15;
  static const int FUN_CANAL_EMS = 0x16;
  static const int FUN_CANAL_EMS_R = 0x17;
  static const int FUN_ALL_CANAL_EMS = 0x18;
  static const int FUN_ALL_CANAL_EMS_R = 0x19;
  static const int FUN_RESET = 0x1A;
  static const int FUN_GET_MEM = 0x1C;
  static const int FUN_GET_MEM_R = 0x1D;
  static const int FUN_SET_MEM = 0x1E;
  static const int FUN_SET_MEM_R = 0x1F;
  static const int FUN_GET_PULSOS = 0x20;
  // Según documentación: FUN_GET_PULSOS_R debe ser 33 (0x21)
  static const int FUN_GET_PULSOS_R = 0x21;

  final FlutterReactiveBle ble;

  // Gestión de suscripciones: por dispositivo y global
  final Map<String, StreamSubscription<List<int>>> _subscriptions = {};
  StreamSubscription<List<int>>? _globalSubscription;

  // ---------------------------
  // COLA DE COMANDOS
  // ---------------------------

  // Cola y flag de procesamiento
  final Queue<_QueuedCommand<dynamic>> _commandQueue = Queue();
  bool _isProcessingQueue = false;

  // Método para encolar comandos.
  // Si bypassQueue es true, el comando se ejecuta inmediatamente.
  Future<T> _enqueueCommand<T>(
      Future<T> Function() command, {
        bool priority = false,
        bool bypassQueue = false,
      }) {
    if (bypassQueue) {
      return command();
    }
    final completer = Completer<T>();
    final queuedCommand = _QueuedCommand<T>(
        command: command, completer: completer, priority: priority);
    if (priority) {
      // Limpiamos la cola y agregamos el comando al frente.
      _commandQueue.clear();
      _commandQueue.addFirst(queuedCommand);
    } else {
      _commandQueue.add(queuedCommand);
    }
    _processQueue();
    return completer.future;
  }

  // Procesa la cola de comandos de manera secuencial.
  void _processQueue() {
    if (_isProcessingQueue) return;
    _isProcessingQueue = true;
    _runQueue();
  }

  Future<void> _runQueue() async {
    while (_commandQueue.isNotEmpty) {
      final queuedCommand = _commandQueue.removeFirst();
      if (queuedCommand.priority) {
        // Antes de ejecutar un comando de prioridad, limpiamos la cola.
        _commandQueue.clear();
      }
      try {
        final result = await queuedCommand.command();
        queuedCommand.completer.complete(result);
      } catch (e, stack) {
        queuedCommand.completer.completeError(e, stack);
      }
      if (queuedCommand.priority) {
        // Después de ejecutar el comando, limpiamos nuevamente la cola.
        _commandQueue.clear();
      }
    }
    _isProcessingQueue = false;
  }

  // ---------------------------
  // CONSTRUCTOR
  // ---------------------------
  BleCommandService({FlutterReactiveBle? bleInstance})
      : ble = bleInstance ?? FlutterReactiveBle();

  // ---------------------------
  // MÉTODOS HELPERS COMUNES
  // ---------------------------
  List<int> _createPacket() => List.filled(PACKET_LENGTH, 0);

  List<int> _padPacket(List<int> packet) {
    final padded = List<int>.from(packet);
    if (padded.length > PACKET_LENGTH) {
      return padded.sublist(0, PACKET_LENGTH);
    }
    while (padded.length < PACKET_LENGTH) {
      padded.add(0);
    }
    return padded;
  }

  QualifiedCharacteristic _getCharacteristic(String macAddress,
      {bool isTx = false}) {
    return QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: isTx ? txCharacteristicUuid : rxCharacteristicUuid,
      deviceId: macAddress,
    );
  }

  Future<void> _cancelSubscription(String macAddress,
      {bool global = false}) async {
    if (global) {
      await _globalSubscription?.cancel();
      _globalSubscription = null;
    } else {
      await _subscriptions[macAddress]?.cancel();
      _subscriptions.remove(macAddress);
    }
  }

  Future<T> _executeBleCommand<T>({
    required String macAddress,
    required int expectedResponseCode,
    required List<int> requestPacket,
    required T Function(List<int> data) parser,
    Duration timeout = const Duration(seconds: 10),
    bool globalSubscription = false,
    required T defaultOnTimeout,
  }) async {
    final rxCharacteristic = _getCharacteristic(macAddress, isTx: false);
    final txCharacteristic = _getCharacteristic(macAddress, isTx: true);

    await _cancelSubscription(macAddress, global: globalSubscription);

    final completer = Completer<T>();

    void listener(List<int> data) {
      if (data.isNotEmpty &&
          data[0] == expectedResponseCode &&
          !completer.isCompleted) {
        try {
          final result = parser(data);
          debugPrint(
              "📥 Respuesta $expectedResponseCode recibida desde $macAddress: $result");
          completer.complete(result);
        } catch (e) {
          completer.completeError(e);
        }
      }
    }

    final subscription = ble
        .subscribeToCharacteristic(txCharacteristic)
        .listen(listener, onError: (error) {
      if (!completer.isCompleted) completer.completeError(error);
    });

    if (globalSubscription) {
      _globalSubscription = subscription;
    } else {
      _subscriptions[macAddress] = subscription;
    }

    try {
      await ble.writeCharacteristicWithResponse(rxCharacteristic,
          value: _padPacket(requestPacket));
      final result = await completer.future.timeout(timeout, onTimeout: () {
        debugPrint(
            "⏱️ Timeout alcanzado para $macAddress, retornando valor por defecto.");
        return defaultOnTimeout;
      });
      return result;
    } finally {
      await subscription.cancel();
      if (globalSubscription) {
        _globalSubscription = null;
      } else {
        _subscriptions.remove(macAddress);
      }
    }
  }

  // ---------------------------
  // MÉTODOS ESPECÍFICOS
  // ---------------------------
  // NOTA: El método initializeSecurity se ejecuta de inmediato (sin encolar)
  Future<bool> initializeSecurity(String macAddress) async {
    final packet = _createPacket();
    packet[0] = FUN_INIT;
    packet[1] = 0;
    debugPrint("Enviando solicitud de seguridad (P=0) a $macAddress");
    return await _executeSecurityChallenge(macAddress, packet);
  }

  Future<bool> _executeSecurityChallenge(String macAddress, List<int> packet) async {
    try {
      final response = await _executeBleCommand<List<int>>(
        macAddress: macAddress,
        expectedResponseCode: FUN_INIT_R,
        requestPacket: packet,
        parser: (data) => data,
        timeout: Duration(seconds: 10),
        defaultOnTimeout: _createPacket(),
        globalSubscription: true,
      );

      int r = response[1];
      if (r == 2) {
        debugPrint("Seguridad ya inicializada (R=2) en $macAddress");
        return true;
      } else if (r == 1) {
        debugPrint(
            "Desafío aceptado (R=1). Seguridad inicializada en $macAddress");
        return true;
      } else if (r == 0) {
        int h1 = response[2],
            h2 = response[3],
            h3 = response[4],
            h4 = response[5];
        int rH1 = h1 ^ 0x2A;
        int rH2 = h2 ^ 0x55;
        int rH3 = h3 ^ 0xAA;
        int rH4 = h4 ^ 0xA2;

        final challengeResponsePacket = _createPacket();
        challengeResponsePacket[0] = FUN_INIT;
        challengeResponsePacket[1] = 1;
        challengeResponsePacket[2] = rH1;
        challengeResponsePacket[3] = rH2;
        challengeResponsePacket[4] = rH3;
        challengeResponsePacket[5] = rH4;
        debugPrint("Enviando respuesta al desafío a $macAddress");

        final response2 = await _executeBleCommand<List<int>>(
          macAddress: macAddress,
          expectedResponseCode: FUN_INIT_R,
          requestPacket: challengeResponsePacket,
          parser: (data) => data,
          timeout: Duration(seconds: 10),
          defaultOnTimeout: _createPacket(),
          globalSubscription: true,
        );

        int r2 = response2[1];
        if (r2 == 1 || r2 == 2) {
          debugPrint(
              "Seguridad establecida correctamente tras respuesta al desafío en $macAddress (R=$r2)");
          return true;
        } else {
          debugPrint("Fallo en la respuesta al desafío en $macAddress. R=$r2");
          return false;
        }
      } else {
        debugPrint("Respuesta desconocida en seguridad en $macAddress: R=$r");
        return false;
      }
    } catch (e) {
      debugPrint("Error en la inicialización de seguridad en $macAddress: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> getDeviceInfo(String macAddress) async {
    return _enqueueCommand<Map<String, dynamic>>(() {
      final requestPacket = _createPacket();
      requestPacket[0] = FUN_INFO;
      return _executeBleCommand<Map<String, dynamic>>(
        macAddress: macAddress,
        expectedResponseCode: FUN_INFO_R,
        requestPacket: requestPacket,
        parser: (data) {
          return {
            'mac': data.sublist(1, 7),
            'tariff': data[7],
            'powerType': data[8],
            'hwVersion': data[9],
            'swCommsVersion': data[10],
            'endpoints': [
              {'type': data[11], 'swVersion': data[12]},
              {'type': data[13], 'swVersion': data[14]},
              {'type': data[15], 'swVersion': data[16]},
              {'type': data[17], 'swVersion': data[18]},
            ],
          };
        },
        timeout: Duration(seconds: 15),
        defaultOnTimeout: {},
      );
    });
  }

  Future<String> getBluetoothName(String macAddress) async {
    return _enqueueCommand<String>(() {
      final requestPacket = _createPacket();
      requestPacket[0] = FUN_GET_NAMEBT;
      return _executeBleCommand<String>(
        macAddress: macAddress,
        expectedResponseCode: FUN_GET_NAMEBT_R,
        requestPacket: requestPacket,
        parser: (data) {
          final nameBytes =
          data.sublist(1).takeWhile((byte) => byte != 0).toList();
          return String.fromCharCodes(nameBytes);
        },
        timeout: Duration(seconds: 10),
        defaultOnTimeout: "",
      );
    });
  }

  Future<Map<String, dynamic>> getBatteryParameters(String macAddress) async {
    return _enqueueCommand<Map<String, dynamic>>(() {
      final requestPacket = _createPacket();
      requestPacket[0] = FUN_GET_PARAMBAT;
      return _executeBleCommand<Map<String, dynamic>>(
        macAddress: macAddress,
        expectedResponseCode: FUN_GET_PARAMBAT_R,
        requestPacket: requestPacket,
        parser: (data) {
          return {
            'batteryStatusRaw': data[3],
            'powerType':
            data[1] == 1 ? "Batería de litio (8.4V)" : "Alimentador AC",
            'batteryModel': data[2] == 0 ? "Por defecto" : "Desconocido",
            'batteryStatus': data[3] == 0
                ? "Muy baja"
                : data[3] == 1
                ? "Baja"
                : data[3] == 2
                ? "Media"
                : data[3] == 3
                ? "Alta"
                : "Llena",
            'temperature': "Sin implementar",
            'compensation': (data[6] << 8) | data[7],
            'voltages': {
              'V1': (data[8] << 8) | data[9],
              'V2': (data[10] << 8) | data[11],
              'V3': (data[12] << 8) | data[13],
              'V4': (data[14] << 8) | data[15],
            },
            'elevatorMax': {
              'endpoint1': data[16],
              'endpoint2': data[17],
              'endpoint3': data[18],
              'endpoint4': data[19],
            },
          };
        },
        timeout: Duration(seconds: 10),
        defaultOnTimeout: {},
      );
    });
  }

  Future<Map<String, dynamic>> getTariffCounters(String macAddress) async {
    return _enqueueCommand<Map<String, dynamic>>(() {
      final requestPacket = _createPacket();
      requestPacket[0] = FUN_GET_CONTADOR;
      return _executeBleCommand<Map<String, dynamic>>(
        macAddress: macAddress,
        expectedResponseCode: FUN_GET_CONTADOR_R,
        requestPacket: requestPacket,
        parser: (data) {
          final tariffStatus = data[1] == 0
              ? "Sin tarifa"
              : data[1] == 1
              ? "Con tarifa"
              : "Con tarifa agotada";
          final totalSeconds =
          (data[2] << 24) | (data[3] << 16) | (data[4] << 8) | data[5];
          final remainingSeconds =
          (data[6] << 24) | (data[7] << 16) | (data[8] << 8) | data[9];
          return {
            'tariffStatus': tariffStatus,
            'totalSeconds': totalSeconds,
            'remainingSeconds': remainingSeconds,
          };
        },
        timeout: Duration(seconds: 10),
        defaultOnTimeout: {},
      );
    });
  }

  Future<bool> setTariffCounter(
      String macAddress, {
        required int writeMode,
        required int writeTotal,
        required int writePartial,
        required int tariff,
        required int totalCounterSeconds,
        required int partialCounterSeconds,
      }) async {
    // Crea un paquete de 20 bytes (todos inicializados en 0)
    final packet = _createPacket();
    packet[0] = FUN_SET_CONTADOR;
    packet[1] = writeMode;
    packet[2] = writeTotal;
    packet[3] = writePartial;
    packet[4] = tariff;
    // Contador total (bytes 5 a 8) en big-endian
    packet[5] = (totalCounterSeconds >> 24) & 0xFF;
    packet[6] = (totalCounterSeconds >> 16) & 0xFF;
    packet[7] = (totalCounterSeconds >> 8) & 0xFF;
    packet[8] = totalCounterSeconds & 0xFF;
    // Contador parcial (bytes 9 a 12) en big-endian
    packet[9]  = (partialCounterSeconds >> 24) & 0xFF;
    packet[10] = (partialCounterSeconds >> 16) & 0xFF;
    packet[11] = (partialCounterSeconds >> 8) & 0xFF;
    packet[12] = partialCounterSeconds & 0xFF;
    // Los bytes 13 a 19 ya están en 0 por _createPacket()

    return _enqueueCommand<bool>(() {
      return _executeBleCommand<bool>(
        macAddress: macAddress,
        expectedResponseCode: FUN_SET_CONTADOR_R,
        requestPacket: packet,
        parser: (data) => data[1] == 1,
        timeout: Duration(seconds: 10),
        defaultOnTimeout: false,
      );
    });
  }


  Future<Map<String, dynamic>> getElectrostimulatorState(
      String macAddress, int endpoint, int mode) async {
    if (endpoint < 1 || endpoint > 4) {
      throw ArgumentError("El endpoint debe estar entre 1 y 4.");
    }
    if (mode < 0 || mode > 2) {
      throw ArgumentError("El modo debe estar entre 0 y 2.");
    }
    return _enqueueCommand<Map<String, dynamic>>(() {
      final requestPacket = _createPacket();
      requestPacket[0] = FUN_GET_ESTADO_EMS;
      requestPacket[1] = endpoint;
      requestPacket[2] = mode;
      return _executeBleCommand<Map<String, dynamic>>(
        macAddress: macAddress,
        expectedResponseCode: FUN_GET_ESTADO_EMS_R,
        requestPacket: requestPacket,
        parser: (data) => _parseElectrostimulatorState(data, mode),
        timeout: Duration(seconds: 10),
        defaultOnTimeout: {},
      );
    });
  }

  Map<String, dynamic> _parseElectrostimulatorState(List<int> data, int mode) {
    final endpoint = data[1];
    final state = mapState(data[2]);
    final batteryStatus = mapBatteryStatus(data[3]);
    final frequency = data[4];
    final ramp = data[5];
    final rawPulseWidth = data[6];
    final pulseWidth = rawPulseWidth == 0 ? "Cronaxia" : rawPulseWidth * 5;
    final limitador = data[9] == 0 ? "No" : "Sí";

    if (mode == 0) {
      final temperature = ((data[7] << 8) | data[8]) / 100.0;
      final channelLevels = data.sublist(10, 20);
      return {
        'endpoint': endpoint,
        'state': state,
        'batteryStatus': batteryStatus,
        'frequency': frequency,
        'ramp': ramp,
        'pulseWidth': pulseWidth,
        'temperature': temperature,
        'limitador': limitador,
        'channelLevels': channelLevels,
      };
    } else if (mode == 1 || mode == 2) {
      final voltage = ((data[7] << 8) | data[8]) / 10.0;
      final channelPulseWidths = data.sublist(10, 20);
      return {
        'endpoint': endpoint,
        'state': state,
        'batteryStatus': batteryStatus,
        'frequency': frequency,
        'ramp': ramp,
        'pulseWidth': pulseWidth,
        'limitador': limitador,
        if (mode == 1)
          'batteryVoltage': voltage
        else
          'elevatorTension': voltage,
        'channelPulseWidths': channelPulseWidths,
      };
    } else {
      throw ArgumentError("Modo inválido.");
    }
  }

  Future<String> fetchAndFormatElectroState({
    required String macAddress,
    required int endpoint,
    required int mode,
  }) async {
    try {
      final stateData =
      await getElectrostimulatorState(macAddress, endpoint, mode);
      String formatted = "ℹ️Estado del electroestimulador:\n";
      formatted += "Endpoint: ${stateData['endpoint']}\n";
      formatted += "Estado: ${stateData['state']}\n";
      formatted += "Estado Batería: ${stateData['batteryStatus']}\n";
      formatted += "Frecuencia: ${stateData['frequency']} Hz\n";
      formatted += "Rampa: ${stateData['ramp']} (x100ms)\n";
      formatted += "Ancho de pulso: ${stateData['pulseWidth']}\n";
      formatted += "Limitador: ${stateData['limitador']}\n";

      if (mode == 0) {
        formatted += "Temperatura: ${stateData['temperature']} °C\n";
        formatted += "Niveles de canales: ${stateData['channelLevels']}\n";
      } else if (mode == 1) {
        formatted += "Tensión de batería: ${stateData['batteryVoltage']} V\n";
        formatted +=
        "Anchura de pulso por canal: ${stateData['channelPulseWidths']}\n";
      } else if (mode == 2) {
        formatted +=
        "Tensión del elevador: ${stateData['elevatorTension']} V\n";
        formatted +=
        "Anchura de pulso por canal: ${stateData['channelPulseWidths']}\n";
      }

      return formatted;
    } catch (e) {
      return "Error al obtener el estado: $e";
    }
  }

  Future<bool> startElectrostimulationSession(String macAddress,
      List<int> valoresCanales, double frecuencia, double rampa,
      {double pulso = 0}) async {
    debugPrint("⚙️ Iniciando sesión de electroestimulación en $macAddress...");
    final runSuccess = await runElectrostimulationSession(
      macAddress: macAddress,
      endpoint: 1,
      limitador: 0,
      rampa: rampa,
      frecuencia: frecuencia,
      deshabilitaElevador: 0,
      nivelCanales: valoresCanales,
      pulso: pulso.toInt(),
      anchuraPulsosPorCanal: List.generate(10, (index) => pulso.toInt()),
    );
    if (runSuccess) {
      debugPrint(
          "✅ Sesión de electroestimulación iniciada correctamente en $macAddress.");
      return true;
    } else {
      debugPrint(
          "❌ Error al iniciar la sesión de electroestimulación en $macAddress.");
      return false;
    }
  }

  Future<bool> runElectrostimulationSession({
    required String macAddress,
    required int endpoint,
    required int limitador,
    required double rampa,
    required double frecuencia,
    required int deshabilitaElevador,
    required List<int> nivelCanales,
    required int pulso,
    required List<int> anchuraPulsosPorCanal,
  }) async {
    if (endpoint < 1 || endpoint > 4) throw ArgumentError("Endpoint inválido.");
    if (anchuraPulsosPorCanal.length != 10) {
      throw ArgumentError(
          "Debe haber exactamente 10 valores de anchura de pulso.");
    }
    return _enqueueCommand<bool>(() {
      final requestPacket = _createPacket();
      requestPacket[0] = FUN_RUN_EMS;
      requestPacket[1] = endpoint;
      requestPacket[2] = limitador;
      requestPacket[3] = rampa.toInt();
      requestPacket[4] = frecuencia.toInt();
      requestPacket[5] = deshabilitaElevador;
      for (int i = 0; i < nivelCanales.length; i++) {
        requestPacket[6 + i] = nivelCanales[i].clamp(0, 100);
      }
      for (int i = 0; i < 10; i++) {
        requestPacket[8 + i] = anchuraPulsosPorCanal[i];
      }
      return _executeBleCommand<bool>(
        macAddress: macAddress,
        expectedResponseCode: FUN_RUN_EMS_R,
        requestPacket: requestPacket,
        parser: (data) => data[2] == 1,
        timeout: Duration(seconds: 20),
        defaultOnTimeout: false,
      );
    });
  }

  // El comando stopElectrostimulationSession se encola con prioridad.
  Future<bool> stopElectrostimulationSession(String macAddress) async {
    return _enqueueCommand<bool>(() async {
      // Limpiar la cola antes de ejecutar el comando stop.
      _commandQueue.clear();
      final requestPacket = _createPacket();
      requestPacket[0] = FUN_STOP_EMS;
      requestPacket[1] = 1;
      final result = await _executeBleCommand<bool>(
        macAddress: macAddress,
        expectedResponseCode: FUN_STOP_EMS_R,
        requestPacket: requestPacket,
        parser: (data) => data[2] == 1,
        timeout: Duration(seconds: 10),
        defaultOnTimeout: false,
      );
      // Limpiar la cola después de ejecutarse.
      _commandQueue.clear();
      return result;
    }, priority: true);
  }

  Future<Map<String, dynamic>> controlElectrostimulatorChannel({
    required String macAddress,
    required int endpoint,
    required int canal,
    required int modo,
    required int valor,
  }) async {
    if (endpoint < 1 || endpoint > 4) {
      throw ArgumentError("El endpoint debe estar entre 1 y 4.");
    }
    if (canal < 0 || canal > 9) {
      throw ArgumentError("El canal debe estar entre 0 y 9.");
    }
    if (modo < 0 || modo > 3) {
      throw ArgumentError(
          "El modo debe ser 0 (absoluto), 1 (incrementa), 2 (decrementa), o 3 (solo retorna valor).");
    }
    if (valor < 0 || valor > 100) {
      throw ArgumentError("El valor debe estar entre 0 y 100.");
    }
    return _enqueueCommand<Map<String, dynamic>>(() {
      final requestPacket = _createPacket();
      requestPacket[0] = FUN_CANAL_EMS;
      requestPacket[1] = endpoint;
      requestPacket[2] = canal;
      requestPacket[3] = modo;
      requestPacket[4] = valor;
      return _executeBleCommand<Map<String, dynamic>>(
        macAddress: macAddress,
        expectedResponseCode: FUN_CANAL_EMS_R,
        requestPacket: requestPacket,
        parser: (data) {
          return {
            'endpoint': data[1],
            'canal': data[2],
            'resultado': data[3] == 1 ? "OK" : "FAIL",
            'valor': data[4] == 200 ? "Limitador activado" : "$valor%",
          };
        },
        timeout: Duration(seconds: 10),
        defaultOnTimeout: {},
      );
    });
  }

  Future<Map<String, dynamic>> controlSingleChannel(
      String macAddress,
      int endpoint,
      int canal,
      int modo,
      int valor,
      ) async {
    try {
      return await controlElectrostimulatorChannel(
        macAddress: macAddress,
        endpoint: endpoint,
        canal: canal,
        modo: modo,
        valor: valor,
      );
    } catch (e) {
      debugPrint("❌ Error al controlar canal $canal en $macAddress: $e");
      return {
        'endpoint': endpoint,
        'canal': canal,
        'resultado': "ERROR",
        'valor': "$valor%"
      };
    }
  }

  Future<Map<String, dynamic>> controlAllElectrostimulatorChannels({
    required String macAddress,
    required int endpoint,
    required int modo,
    required List<int> valoresCanales,
  }) async {
    if (endpoint < 1 || endpoint > 4) {
      throw ArgumentError("El endpoint debe estar entre 1 y 4.");
    }
    if (modo < 0 || modo > 3) {
      throw ArgumentError(
          "El modo debe ser 0 (absoluto), 1 (incrementa), 2 (decrementa), o 3 (solo retorna valores).");
    }
    if (valoresCanales.length != 7 && valoresCanales.length != 10) {
      throw ArgumentError(
          "La lista de valoresCanales debe tener exactamente 7 o 10 elementos.");
    }
    if (valoresCanales.any((valor) => valor < 0 || valor > 100)) {
      throw ArgumentError(
          "Todos los valores de los canales deben estar entre 0 y 100.");
    }
    return _enqueueCommand<Map<String, dynamic>>(() {
      final requestPacket = _createPacket();
      requestPacket[0] = FUN_ALL_CANAL_EMS;
      requestPacket[1] = endpoint;
      requestPacket[2] = modo;
      for (int i = 0; i < valoresCanales.length; i++) {
        requestPacket[3 + i] = valoresCanales[i];
      }
      return _executeBleCommand<Map<String, dynamic>>(
        macAddress: macAddress,
        expectedResponseCode: FUN_ALL_CANAL_EMS_R,
        requestPacket: requestPacket,
        parser: (data) {
          final valoresResp = data.sublist(3, 13).map((v) {
            return v == 200 ? "Limitador activado" : "$v%";
          }).toList();
          return {
            'endpoint': data[1],
            'resultado': data[2] == 1 ? "OK" : "FAIL",
            'valoresCanales': valoresResp,
          };
        },
        timeout: Duration(seconds: 10),
        defaultOnTimeout: {},
      );
    });
  }

  Future<Map<String, dynamic>> controlAllChannels(String macAddress,
      int endpoint, int modo, List<int> valoresCanales) async {
    try {
      return await controlAllElectrostimulatorChannels(
        macAddress: macAddress,
        endpoint: endpoint,
        modo: modo,
        valoresCanales: valoresCanales,
      );
    } catch (e) {
      debugPrint("❌ Error al controlar canales en $macAddress: $e");
      return {
        'endpoint': endpoint,
        'resultado': "ERROR",
        'valoresCanales': [],
      };
    }
  }

  Future<bool> performShutdown({
    required String macAddress,
    int temporizado = 0,
  }) async {
    return _enqueueCommand<bool>(() async {
      final rxCharacteristic = _getCharacteristic(macAddress);
      try {
        debugPrint("🔄 Enviando comando de shutdown a $macAddress...");
        final shutdownPacket = _createPacket();
        shutdownPacket[0] = FUN_RESET;
        shutdownPacket[1] = 0x66;
        shutdownPacket[2] = temporizado;
        await ble.writeCharacteristicWithResponse(rxCharacteristic,
            value: shutdownPacket);
        debugPrint("✅ Shutdown enviado correctamente.");
        return true;
      } catch (e) {
        debugPrint("❌ Error en shutdown para $macAddress: $e");
        return false;
      }
    });
  }

  Future<Map<String, dynamic>> getFreeMemory({
    required String macAddress,
    required int pagina,
  }) async {
    if (pagina < 0 || pagina > 31) {
      throw ArgumentError("La página debe estar entre 0 y 31.");
    }
    return _enqueueCommand<Map<String, dynamic>>(() {
      final requestPacket = _createPacket();
      requestPacket[0] = FUN_GET_MEM;
      requestPacket[1] = pagina;
      return _executeBleCommand<Map<String, dynamic>>(
        macAddress: macAddress,
        expectedResponseCode: FUN_GET_MEM_R,
        requestPacket: requestPacket,
        parser: (data) {
          return {
            'status': data[1] == 1 ? "OK" : "FAIL",
            'pagina': data[2],
            'datos': data.sublist(3, 19),
          };
        },
        timeout: Duration(seconds: 10),
        defaultOnTimeout: {},
        globalSubscription: true,
      );
    });
  }

  Future<bool> setFreeMemory({
    required String macAddress,
    required int pagina,
    required List<int> datos,
  }) async {
    if (pagina < 0 || pagina > 31) {
      throw ArgumentError("La página debe estar entre 0 y 31.");
    }
    if (datos.length != 16) {
      throw ArgumentError("Los datos deben tener exactamente 16 bytes.");
    }
    return _enqueueCommand<bool>(() {
      final requestPacket = [FUN_SET_MEM, pagina, ...datos];
      return _executeBleCommand<bool>(
        macAddress: macAddress,
        expectedResponseCode: FUN_SET_MEM_R,
        requestPacket: requestPacket,
        parser: (data) => data[1] == 1,
        timeout: Duration(seconds: 10),
        defaultOnTimeout: false,
        globalSubscription: true,
      );
    });
  }

  Future<Map<String, dynamic>> getPulseMeter({
    required String macAddress,
    required int endpoint,
  }) async {
    if (endpoint < 1 || endpoint > 4) {
      throw ArgumentError("El endpoint debe estar entre 1 y 4.");
    }
    return _enqueueCommand<Map<String, dynamic>>(() {
      final requestPacket = _createPacket();
      requestPacket[0] = FUN_GET_PULSOS;
      requestPacket[1] = endpoint;
      return _executeBleCommand<Map<String, dynamic>>(
        macAddress: macAddress,
        expectedResponseCode: FUN_GET_PULSOS_R,
        requestPacket: requestPacket,
        parser: (data) {
          return {
            'endpoint': data[1],
            'status': mapPulseMeterStatus(data[2]),
            'bps': (data[3] << 8) | data[4],
            'SpO2': (data[5] << 8) | data[6],
          };
        },
        timeout: Duration(seconds: 15),
        defaultOnTimeout: {
          'endpoint': endpoint,
          'status': "Timeout",
          'bps': 0,
          'SpO2': 0,
        },
        globalSubscription: true,
      );
    });
  }

  Future<bool> getSignalCable(String macAddress, int endpoint) async {
    try {
      final pulseMeterResponse =
      await getPulseMeter(macAddress: macAddress, endpoint: endpoint);
      if (pulseMeterResponse['status'] != "OK") {
        debugPrint(
            "❌ Pulsómetro no operativo en $macAddress: ${pulseMeterResponse['status']}");
        return false;
      }
      return true;
    } catch (e) {
      debugPrint("❌ Error al obtener pulsómetro en $macAddress: $e");
      return false;
    }
  }

  String mapPulseMeterStatus(int status) {
    switch (status) {
      case 0:
        return "No existe";
      case 1:
        return "Sensor desconectado o con error";
      case 2:
        return "Sensor no capta";
      case 3:
        return "OK";
      default:
        return "Desconocido";
    }
  }

  String mapState(int state) {
    const states = {
      0: "POWER OFF",
      1: "CHARGE",
      2: "STOP",
      3: "RUN RAMPA",
      4: "RUN",
      10: "CLOSING",
      100: "LIMITE TARIFA",
      101: "ERROR POR FALLO INTERNO",
      102: "ERROR FALLO ELEVADOR",
      103: "ERROR SOBRE-TEMPERATURA",
      104: "ERROR TENSIÓN ALIMENTACIÓN FUERA DEL RANGO",
    };
    return states[state] ?? "Estado desconocido";
  }

  String mapBatteryStatus(int status) {
    switch (status) {
      case 0:
        return "Muy baja";
      case 1:
        return "Baja";
      case 2:
        return "Media";
      case 3:
        return "Alta";
      case 4:
        return "Llena";
      default:
        return "Desconocido";
    }
  }

  // MÉTODOS PARA PARSEAR RESPUESTAS (UI)
  String parseDeviceInfo(Map<String, dynamic> deviceInfo) {
    final mac = (deviceInfo['mac'] as List<int>)
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(':');
    final tariff = deviceInfo['tariff'] == 0
        ? "Sin tarifa"
        : deviceInfo['tariff'] == 1
        ? "Con tarifa"
        : "Con tarifa agotada";
    final powerType = deviceInfo['powerType'] == 0
        ? "Fuente de alimentación"
        : "Batería de litio (8.4V)";
    final endpoints = (deviceInfo['endpoints'] as List<Map<String, dynamic>>)
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final ep = entry.value;
      final type = ep['type'] == 0
          ? "Ninguno"
          : ep['type'] == 1
          ? "Electroestimulador (10 canales normal)"
          : ep['type'] == 2
          ? "Electroestimulador (10 canales + Ctrl Input)"
          : "Desconocido";
      return "  Endpoint ${index + 1}: Tipo: $type, Versión SW: ${ep['swVersion']}";
    }).join('\n');
    return '''
📊 Información del dispositivo:
- Dirección MAC: $mac
- Tarifa: $tariff
- Tipo de alimentación: $powerType
- Versión HW: ${deviceInfo['hwVersion']}
- Versión SW de comunicaciones: ${deviceInfo['swCommsVersion']}
$endpoints
''';
  }

  String parseBatteryParameters(Map<String, dynamic> batteryParameters) {
    final voltages = batteryParameters['voltages'] as Map<String, int>;
    final elevatorMax = batteryParameters['elevatorMax'] as Map<String, int>;
    return '''
🔋 Parámetros de la batería:
- Tipo de alimentación: ${batteryParameters['powerType']}
- Modelo de batería: ${batteryParameters['batteryModel']}
- Estado de la batería: ${batteryParameters['batteryStatus']}
- Compensación: ${batteryParameters['compensation']}
- Voltajes:
  - V1: ${voltages['V1']} mV
  - V2: ${voltages['V2']} mV
  - V3: ${voltages['V3']} mV
  - V4: ${voltages['V4']} mV
- Elevador máximo:
  - Endpoint 1: ${elevatorMax['endpoint1']}
  - Endpoint 2: ${elevatorMax['endpoint2']}
  - Endpoint 3: ${elevatorMax['endpoint3']}
  - Endpoint 4: ${elevatorMax['endpoint4']}
''';
  }

  String parseTariffCounters(Map<String, dynamic> counters) {
    String formatDuration(Duration duration) {
      final h = duration.inHours;
      final m = duration.inMinutes.remainder(60);
      final s = duration.inSeconds.remainder(60);
      return "${h}h ${m}m ${s}s";
    }

    final totalTime = Duration(seconds: counters['totalSeconds']);
    final remainingTime = Duration(seconds: counters['remainingSeconds']);
    return '''
⏳ Contadores de tarifa:
- Estado de tarifa: ${counters['tariffStatus']}
- Tiempo total utilizado: ${formatDuration(totalTime)} (${counters['totalSeconds']}s)
- Tiempo restante de tarifa: ${formatDuration(remainingTime)} (${counters['remainingSeconds']}s)
''';
  }

  String parseChannelControlResponse(Map<String, dynamic> response) {
    return '''
🎛️ Control del canal del electroestimulador:
- Endpoint: ${response['endpoint']}
- Canal: ${response['canal']}
- Resultado: ${response['resultado']}
- Valor: ${response['valor']}
''';
  }

  String parseAllChannelsResponse(Map<String, dynamic> response) {
    final canales = (response['valoresCanales'] as List)
        .asMap()
        .entries
        .map((entry) => "  Canal ${entry.key + 1}: ${entry.value}")
        .join('\n');
    return '''
🎚️ Control de todos los canales:
- Endpoint: ${response['endpoint']}
- Resultado: ${response['resultado']}
$canales
''';
  }

  Future<void> disposeSubs() async {
    await _globalSubscription?.cancel();
    _globalSubscription = null;
    for (final sub in _subscriptions.values) {
      await sub.cancel();
    }
    _subscriptions.clear();
  }
}

class _QueuedCommand<T> {
  final Future<T> Function() command;
  final Completer<T> completer;
  final bool priority; // true para STOPSESSION

  _QueuedCommand({
    required this.command,
    required this.completer,
    this.priority = false,
  });
}