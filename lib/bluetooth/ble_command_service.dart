import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

enum CommandCategory { electroState, run, stop, control }

class _QueuedCommand<T> {
  final Future<T> Function() command;
  final Completer<T> completer;
  final CommandCategory category;

  _QueuedCommand({
    required this.command,
    required this.completer,
    required this.category,
  });
}

/// Un simple mutex para evitar concurrencia en el acceso a BLE.
class SimpleLock {
  Future<void>? _lock;
  Future<T> synchronized<T>(Future<T> Function() computation) async {
    while (_lock != null) {
      await _lock;
    }
    final completer = Completer<void>();
    _lock = completer.future;
    try {
      return await computation();
    } finally {
      _lock = null;
      completer.complete();
    }
  }
}

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
  static const int FUN_SET_CONTADOR = 0x0E;
  static const int FUN_SET_CONTADOR_R = 0x0F;
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
  static const int FUN_GET_PULSOS_R = 0x21;

  final FlutterReactiveBle ble;

  // Gestión de suscripciones: por dispositivo y global
  final Map<String, StreamSubscription<List<int>>> _subscriptions = {};
  StreamSubscription<List<int>>? _globalSubscription;

  // ---------------------------
  // COLAS POR CATEGORÍA
  // ---------------------------
  final Queue<_QueuedCommand<dynamic>> _electroStateQueue = Queue();
  // Para los comandos de control (run, stop, control)
  final Queue<_QueuedCommand<dynamic>> _otherQueue = Queue();

  bool _isElectroStateProcessing = false;
  bool _isOtherProcessing = false;

  // Mapa para almacenar el identificador de la solicitud GET actual por dispositivo.
  final Map<String, int> _latestElectroStateRequestId = {};

  // Un mutex para evitar que se ejecuten dos comandos BLE simultáneamente.
  final SimpleLock _bleLock = SimpleLock();

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

  // ---------------------------
  // EJECUCIÓN DE COMANDOS BLE (sin cola)
  // ---------------------------
  Future<T> _executeBleCommand<T>({
    required String macAddress,
    required int expectedResponseCode,
    required List<int> requestPacket,
    required T Function(List<int> data) parser,
    Duration timeout = const Duration(seconds: 2),
    bool globalSubscription = false,
    required T defaultOnTimeout,
  }) {
    // Usamos el mutex para garantizar que sólo se ejecute un comando BLE a la vez.
    return _bleLock.synchronized(() async {
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
            debugPrint("📥 Respuesta $expectedResponseCode recibida desde $macAddress: $result");
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
          debugPrint("⏱️ Timeout para $macAddress, retornando valor por defecto.");
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
    });
  }

  // ---------------------------
  // MÉTODO PARA ENCOLAR COMANDOS SEGÚN CATEGORÍA
  // ---------------------------
  Future<T> _enqueueCommand<T>(
      Future<T> Function() command, {
        required CommandCategory category,
        bool bypassQueue = false,
      }) {
    if (bypassQueue) {
      // Ejecuta el comando inmediatamente sin encolarlo.
      return command();
    }
    final completer = Completer<T>();
    final queuedCommand = _QueuedCommand<T>(
      command: command,
      completer: completer,
      category: category,
    );

    if (category == CommandCategory.electroState) {
      _electroStateQueue.add(queuedCommand);
      _processElectroStateQueue();
    } else {
      _otherQueue.add(queuedCommand);
      _processOtherQueue();
    }
    return completer.future;
  }

  // ---------------------------
  // PROCESAMIENTO DE LA COLA GET (electroState)
  // ---------------------------
  void _processElectroStateQueue() {
    if (_isElectroStateProcessing) return;
    _isElectroStateProcessing = true;
    _runElectroStateQueueProcessor();
  }

  Future<void> _runElectroStateQueueProcessor() async {
    while (_electroStateQueue.isNotEmpty) {
      final cmd = _electroStateQueue.removeFirst();
      try {
        final result = await cmd.command();
        cmd.completer.complete(result);
      } catch (e, stack) {
        cmd.completer.completeError(e, stack);
      }
    }
    _isElectroStateProcessing = false;
  }

  // ---------------------------
  // PROCESAMIENTO DE LA COLA DE OTROS COMANDOS
  // ---------------------------
  void _processOtherQueue() {
    if (_isOtherProcessing) return;
    _isOtherProcessing = true;
    _runOtherQueueProcessor();
  }

  Future<void> _runOtherQueueProcessor() async {
    while (_otherQueue.isNotEmpty) {
      final cmd = _otherQueue.removeFirst();
      try {
        final result = await cmd.command();
        cmd.completer.complete(result);
      } catch (e, stack) {
        cmd.completer.completeError(e, stack);
      }
    }
    _isOtherProcessing = false;
  }

  // ---------------------------
  // MÉTODOS ESPECÍFICOS
  // ---------------------------

  Future<bool> initializeSecurity(String macAddress) async {
    final packet = _createPacket();
    packet[0] = FUN_INIT;
    packet[1] = 0;
    debugPrint("Enviando solicitud de seguridad (P=0) a $macAddress");
    return await _executeSecurityChallenge(macAddress, packet);
  }

  Future<bool> _executeSecurityChallenge(
      String macAddress, List<int> packet) async {
    try {
      final response = await _executeBleCommand<List<int>>(
        macAddress: macAddress,
        expectedResponseCode: FUN_INIT_R,
        requestPacket: packet,
        parser: (data) => data,
        timeout: Duration(seconds: 2),
        defaultOnTimeout: _createPacket(),
        globalSubscription: true,
      );

      int r = response[1];
      if (r == 2) {
        debugPrint("Seguridad ya inicializada (R=2) en $macAddress");
        return true;
      } else if (r == 1) {
        debugPrint("Desafío aceptado (R=1). Seguridad inicializada en $macAddress");
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
          timeout: Duration(seconds: 2),
          defaultOnTimeout: _createPacket(),
          globalSubscription: true,
        );

        int r2 = response2[1];
        if (r2 == 1 || r2 == 2) {
          debugPrint("Seguridad establecida correctamente tras respuesta al desafío en $macAddress (R=$r2)");
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
      timeout: Duration(seconds: 2),
      defaultOnTimeout: {},
    );
  }

  Future<String> getBluetoothName(String macAddress) async {
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
      timeout: Duration(seconds: 2),
      defaultOnTimeout: "",
    );
  }

  Future<Map<String, dynamic>> getBatteryParameters(String macAddress) async {
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
      timeout: Duration(seconds: 2),
      defaultOnTimeout: {},
    );
  }

  Future<Map<String, dynamic>> getTariffCounters(String macAddress) async {
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
      timeout: Duration(seconds: 2),
      defaultOnTimeout: {},
    );
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
    final packet = _createPacket();
    packet[0] = FUN_SET_CONTADOR;
    packet[1] = writeMode;
    packet[2] = writeTotal;
    packet[3] = writePartial;
    packet[4] = tariff;
    packet[5] = (totalCounterSeconds >> 24) & 0xFF;
    packet[6] = (totalCounterSeconds >> 16) & 0xFF;
    packet[7] = (totalCounterSeconds >> 8) & 0xFF;
    packet[8] = totalCounterSeconds & 0xFF;
    packet[9] = (partialCounterSeconds >> 24) & 0xFF;
    packet[10] = (partialCounterSeconds >> 16) & 0xFF;
    packet[11] = (partialCounterSeconds >> 8) & 0xFF;
    packet[12] = partialCounterSeconds & 0xFF;
    return _executeBleCommand<bool>(
      macAddress: macAddress,
      expectedResponseCode: FUN_SET_CONTADOR_R,
      requestPacket: packet,
      parser: (data) => data[1] == 1,
      timeout: Duration(seconds: 2),
      defaultOnTimeout: false,
    );
  }

  // -----------
  // SEPARANDO EL GET ELECTROSTATE (cola exclusiva y requestId)
  // -----------
  Future<Map<String, dynamic>> getElectrostimulatorState(
      String macAddress, int endpoint, int mode) async {
    if (endpoint < 1 || endpoint > 4) {
      throw ArgumentError("El endpoint debe estar entre 1 y 4.");
    }
    if (mode < 0 || mode > 2) {
      throw ArgumentError("El modo debe estar entre 0 y 2.");
    }

    // Generar un identificador único para esta solicitud
    final int currentRequestId =
        (_latestElectroStateRequestId[macAddress] ?? 0) + 1;
    _latestElectroStateRequestId[macAddress] = currentRequestId;

    // Crear paquete de solicitud
    final requestPacket = _createPacket();
    requestPacket[0] = FUN_GET_ESTADO_EMS; // Código de función
    requestPacket[1] = endpoint; // Endpoint de electroestimulación
    requestPacket[2] = mode; // Modo (0 = temperatura, 1 = voltaje batería, 2 = voltaje elevador)

    debugPrint("📡 Enviando solicitud GET estado EMS con mode: $mode");

    return _enqueueCommand<Map<String, dynamic>>(() {
      return _executeBleCommand<Map<String, dynamic>>(
        macAddress: macAddress,
        expectedResponseCode: FUN_GET_ESTADO_EMS_R,
        requestPacket: requestPacket,
        parser: (data) {
          if (currentRequestId != _latestElectroStateRequestId[macAddress]) {
            throw Exception("❌ Respuesta GET obsoleta, ignorando...");
          }
          return _parseElectrostimulatorState(data, mode);
        },
        timeout: Duration(seconds: 1),
        defaultOnTimeout: {},
      );
    }, category: CommandCategory.electroState);
  }

  Map<String, dynamic> _parseElectrostimulatorState(List<int> data, int mode) {
    final endpoint = data[1];
    final state = mapState(data[2]); // Estado del electroestimulador (RUN, STOP, etc.)

    // Utilizamos la misma lógica que en getBatteryParameters:
    final String batteryStatus = data[3] == 0
        ? "Muy baja"
        : data[3] == 1
        ? "Baja"
        : data[3] == 2
        ? "Media"
        : data[3] == 3
        ? "Alta"
        : "Llena";

    final frequency = data[4]; // Frecuencia
    final ramp = data[5]; // Rampa en x100ms
    final rawPulseWidth = data[6];
    final pulseWidth = rawPulseWidth == 0 ? "Cronaxia" : rawPulseWidth * 5; // Ancho de pulso (x5 μs)
    final limitador = data[9] == 0 ? "No" : "Sí"; // Limitador activado o no

    // 📌 Manejo de modos
    if (mode == 0) {
      final temperature = ((data[7] << 8) | data[8]) / 100.0; // Conversión correcta
      final channelLevels = data.sublist(10, 20); // Valores de los canales

      debugPrint("📥 Estado EMS (Modo 0): Temp: $temperature°C, Niveles: $channelLevels");

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
      final voltage = ((data[7] << 8) | data[8]) / 10.0; // Conversión correcta
      final channelPulseWidths = data.sublist(10, 20); // Anchos de pulso por canal

      debugPrint("📥 Estado EMS (Modo $mode): Voltaje: $voltage, Pulso: $channelPulseWidths");

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
      throw ArgumentError("❌ Modo inválido.");
    }
  }


  Future<bool> startElectrostimulationSession(
      String macAddress,
      List<int> valoresCanales,
      double frecuencia,
      double rampa, {
        double pulso = 0,
      }) async {
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
      debugPrint("✅ Sesión de electroestimulación iniciada correctamente en $macAddress.");
      return true;
    } else {
      debugPrint("❌ Error al iniciar la sesión de electroestimulación en $macAddress.");
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
    if (endpoint < 1 || endpoint > 4)
      throw ArgumentError("Endpoint inválido.");
    if (anchuraPulsosPorCanal.length != 10) {
      throw ArgumentError("Debe haber exactamente 10 valores de anchura de pulso.");
    }

    final requestPacket = _createPacket();
    requestPacket[0] = FUN_RUN_EMS;  // Código de la función
    requestPacket[1] = endpoint;  // Endpoint (Debe ser 1 para EMS)
    requestPacket[2] = limitador;  // 0 = No, 1 = Sí
    requestPacket[3] = rampa.toInt();  // Rampa en x100ms
    requestPacket[4] = frecuencia.toInt();  // Frecuencia en Hz
    requestPacket[5] = deshabilitaElevador;  // 0 = No, 1 = Sí

    // 📌 Detectar si todos los valores de los canales son iguales
    bool todosIguales = nivelCanales.every((nivel) => nivel == nivelCanales[0]);

    if (todosIguales) {
      // 📌 Si todos los canales tienen el mismo valor, usamos ese valor en `[6]`
      requestPacket[6] = nivelCanales[0].clamp(0, 100);
      debugPrint("🔹 Modo global: Usando ${requestPacket[6]} para todos los canales.");
    } else {
      // 📌 Si los canales tienen valores diferentes, usamos `255` en `[6]` y los asignamos individualmente en `[8-17]`
      requestPacket[6] = 255;
      for (int i = 0; i < 10; i++) {
        requestPacket[8 + i] = nivelCanales[i].clamp(0, 100);
      }
      debugPrint("🔹 Modo individual: Configurando cada canal por separado.");
    }

    // 📌 Si `pulso` es 0, el BLE usará los valores individuales por canal
    requestPacket[7] = pulso > 0 ? pulso.toInt() : 0;

    debugPrint("📡 Enviando paquete de sesión EMS: $requestPacket");

    return _enqueueCommand<bool>(() {
      return _executeBleCommand<bool>(
        macAddress: macAddress,
        expectedResponseCode: FUN_RUN_EMS_R,
        requestPacket: requestPacket,
        parser: (data) => data[2] == 1,
        timeout: Duration(seconds: 2),
        defaultOnTimeout: false,
      );
    }, category: CommandCategory.run);
  }


  Future<bool> stopElectrostimulationSession(String macAddress) async {
    return _enqueueCommand<bool>(() {
      final requestPacket = _createPacket();
      requestPacket[0] = FUN_STOP_EMS;
      requestPacket[1] = 1;
      return _executeBleCommand<bool>(
        macAddress: macAddress,
        expectedResponseCode: FUN_STOP_EMS_R,
        requestPacket: requestPacket,
        parser: (data) => data[2] == 1,
        timeout: Duration(seconds: 2),
        defaultOnTimeout: false,
      );
    }, category: CommandCategory.stop, bypassQueue: true);
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
      throw ArgumentError("El modo debe ser 0 (absoluto), 1 (incrementa), 2 (decrementa) o 3 (solo retorna valor).");
    }
    if (valor < 0 || valor > 100) {
      throw ArgumentError("El valor debe estar entre 0 y 100.");
    }
    final requestPacket = _createPacket();
    requestPacket[0] = FUN_CANAL_EMS;
    requestPacket[1] = endpoint;
    requestPacket[2] = canal;
    requestPacket[3] = modo;
    requestPacket[4] = valor;
    return _enqueueCommand<Map<String, dynamic>>(() {
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
        timeout: Duration(seconds: 2),
        defaultOnTimeout: {},
      );
    }, category: CommandCategory.control);
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
      throw ArgumentError("El modo debe ser 0 (absoluto), 1 (incrementa), 2 (decrementa) o 3 (solo retorna valores).");
    }
    if (valoresCanales.length != 7 && valoresCanales.length != 10) {
      throw ArgumentError("La lista de valoresCanales debe tener exactamente 7 o 10 elementos.");
    }
    if (valoresCanales.any((valor) => valor < 0 || valor > 100)) {
      throw ArgumentError("Todos los valores de los canales deben estar entre 0 y 100.");
    }
    final requestPacket = _createPacket();
    requestPacket[0] = FUN_ALL_CANAL_EMS;
    requestPacket[1] = endpoint;
    requestPacket[2] = modo;
    for (int i = 0; i < valoresCanales.length; i++) {
      requestPacket[3 + i] = valoresCanales[i];
    }
    return _enqueueCommand<Map<String, dynamic>>(() {
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
        timeout: Duration(seconds: 2),
        defaultOnTimeout: {},
      );
    }, category: CommandCategory.control);
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
  }
  Future<Map<String, dynamic>> getFreeMemory({
    required String macAddress,
    required int pagina,
  }) async {
    if (pagina < 0 || pagina > 31) {
      throw ArgumentError("La página debe estar entre 0 y 31.");
    }

    final requestPacket = _createPacket();
    requestPacket[0] = FUN_GET_MEM;
    requestPacket[1] = pagina;

    return _executeBleCommand<Map<String, dynamic>>(
      macAddress: macAddress,
      expectedResponseCode: FUN_GET_MEM_R,
      requestPacket: requestPacket,
      parser: (data) {
        final status = data[1] == 1 ? "OK" : "FAIL";
        final pagina = data[2];
        final rawDatos = data.sublist(3, 19);

        // Convertir a valores útiles
        String hexString = rawDatos.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
        String asciiString = String.fromCharCodes(rawDatos.where((b) => b >= 32 && b <= 126));
        int numericValue = rawDatos.fold(0, (prev, b) => (prev << 8) | b);

        return {
          'status': status,
          'pagina': pagina,
          'datos': rawDatos,
          'hex': hexString,
          'ascii': asciiString.isNotEmpty ? asciiString : "No ASCII",
          'numeric': numericValue,
        };
      },
      timeout: Duration(seconds: 2),
      defaultOnTimeout: {},
      globalSubscription: true,
    );
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
    final requestPacket = [FUN_SET_MEM, pagina, ...datos];
    return _executeBleCommand<bool>(
      macAddress: macAddress,
      expectedResponseCode: FUN_SET_MEM_R,
      requestPacket: requestPacket,
      parser: (data) => data[1] == 1,
      timeout: Duration(seconds: 2),
      defaultOnTimeout: false,
      globalSubscription: true,
    );
  }

  Future<Map<String, dynamic>> getPulseMeter({
    required String macAddress,
    required int endpoint,
  }) async {
    // Validamos que el endpoint esté entre 1 y 4 según la documentación.
    if (endpoint < 1 || endpoint > 4) {
      throw ArgumentError("El endpoint debe estar entre 1 y 4.");
    }

    final requestPacket = _createPacket();
    // Asignamos el código de función para solicitar el pulsómetro.
    requestPacket[0] = FUN_GET_PULSOS; // 0x20 (32)
    // Se coloca el endpoint en la posición 1.
    requestPacket[1] = endpoint;

    debugPrint("📡 Solicitando datos del pulsómetro en endpoint $endpoint a $macAddress");

    return _executeBleCommand<Map<String, dynamic>>(
      macAddress: macAddress,
      expectedResponseCode: FUN_GET_PULSOS_R, // 0x21 (33)
      requestPacket: requestPacket,
      parser: (data) {
        // Se espera que la respuesta tenga al menos 7 bytes.
        if (data.length < 7) {
          throw Exception("Respuesta incompleta del pulsómetro");
        }

        final int respEndpoint = data[1];
        final int statusCode = data[2];
        final int bps = (data[3] << 8) | data[4];
        final int spO2 = (data[5] << 8) | data[6];

        debugPrint("📥 Respuesta pulsómetro en endpoint $respEndpoint: status=$statusCode, bps=$bps, SpO₂=$spO2");

        return {
          'endpoint': respEndpoint,
          'status': mapPulseMeterStatus(statusCode),
          'bps': bps,
          'SpO2': spO2,
        };
      },
      timeout: Duration(seconds: 2),
      defaultOnTimeout: {
        'endpoint': endpoint,
        'status': "Timeout", // En caso de timeout, se retorna este estado.
        'bps': 0,
        'SpO2': 0,
      },
      globalSubscription: true, // Se usa una suscripción global para actualizaciones.
    );
  }

  Future<bool> getSignalCable(String macAddress, int endpoint) async {
    try {
      final pulseMeterResponse = await getPulseMeter(macAddress: macAddress, endpoint: endpoint);
      if (pulseMeterResponse['status'] != "OK") {
        debugPrint("❌ Pulsómetro no operativo en $macAddress: ${pulseMeterResponse['status']}");
        return false;  // Retorna false si el pulsómetro no está OK
      }
      return true;  // Retorna true si el pulsómetro está en estado OK
    } catch (e) {
      debugPrint("❌ Error al obtener pulsómetro en $macAddress: $e");
      return false;  // Retorna false si ocurre un error en la consulta
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
