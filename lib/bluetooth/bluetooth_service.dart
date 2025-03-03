import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'ble_command_service.dart';


class BleConnectionService {
  final flutterReactiveBle = FlutterReactiveBle();
  final BleCommandService bleCommandService = BleCommandService();
  List<String> targetDeviceIds = []; // List to store MAC addresses
  final List<String> connectedDevices = []; // List of connected MACs
  final Map<String, StreamController<bool>> _deviceConnectionStateControllers =
  {};
  final Map<String, StreamSubscription<ConnectionStateUpdate>> _connectionStreams = {};
  final StreamController<Map<String, dynamic>> _deviceUpdatesController =
  StreamController.broadcast();


  /// 🎯 **Get stream of a device's connection status**
  Stream<bool> connectionStateStream(String macAddress) {
    _deviceConnectionStateControllers.putIfAbsent(
        macAddress, () => StreamController<bool>.broadcast());
    return _deviceConnectionStateControllers[macAddress]!.stream;
  }


  void updateDeviceConnectionState(String macAddress, bool isConnected) {
    _deviceConnectionStateControllers.putIfAbsent(
        macAddress, () => StreamController<bool>.broadcast());

    final controller = _deviceConnectionStateControllers[macAddress]!;

    if (!controller.isClosed) {
      controller.add(isConnected);
      debugPrint("🔄 Connection status updated for $macAddress: ${isConnected ? 'connected' : 'disconnected'}");
    }

    // If the device disconnects, flush data and close the stream
    if (!isConnected) {
      emitDeviceUpdate(macAddress, 'bluetoothName', "");
      emitDeviceUpdate(macAddress, 'batteryStatus', -1);

      _deviceConnectionStateControllers[macAddress]?.close();
      _deviceConnectionStateControllers.remove(macAddress);
    }
  }


  // Call this to update the device state
  void updateBluetoothName(String macAddress, String name) {
    emitDeviceUpdate(macAddress, 'bluetoothName', name);
  }

  void updateBatteryStatus(String macAddress, int status) {
    emitDeviceUpdate(macAddress, 'batteryStatus', status);
  }

  Stream<Map<String, dynamic>> get deviceUpdates =>
      _deviceUpdatesController.stream;

  /// 📡 **Issue device updates**
  void emitDeviceUpdate(String macAddress, String key, dynamic value) {
    _deviceUpdatesController.add({'macAddress': macAddress, key: value});
  }





  Future<void> updateMacAddresses(List<String> macAddresses) async {
    targetDeviceIds.clear();
    connectedDevices.clear();

    targetDeviceIds.addAll(macAddresses);
    debugPrint("🔄 Updated target device list: $targetDeviceIds");

    List<String> availableDevices = await scanTargetDevices();

    for (String deviceId in availableDevices) {
      if (!connectedDevices.contains(deviceId)) {
        connectToDeviceByMac(deviceId);
      }
    }
  }

  Future<List<String>> scanTargetDevices() async {
    List<String> availableDevices = [];

    debugPrint("🔎 Starting scanning for devices in the target list...");

    final scanSubscription = flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
      if (targetDeviceIds.contains( device.id ) && !availableDevices.contains( device.id )) {
        availableDevices.add( device.id );
        debugPrint("✅ Device found: ${ device.id } - ${ device.name }");
      }
    }, onError: (error) {
      debugPrint("❌ Error during scanning: $error");
    });

    await Future.delayed(Duration(seconds: 2)); // Scan for 5 seconds
    await scanSubscription.cancel();

    debugPrint("🔍 Scan completed. Available devices: $availableDevices");
    return availableDevices;
  }


  /// 📶 **Connect to a BLE device via MAC**
  Future<bool> connectToDeviceByMac(String deviceId) async {
    if (deviceId. isEmpty) {
      debugPrint("⚠️ Empty device ID. Connection cancelled.");
      return false;
    }

    if (connectedDevices.contains(deviceId)) {
      debugPrint("🔗 Device $deviceId already connected.");
      return true;
    }

    debugPrint("🚩 Trying to connect to device with ID: $deviceId...");

    try {
      // Cancel any previous connections to avoid conflicts
      _connectionStreams[deviceId]?.cancel();

      _connectionStreams[deviceId] = flutterReactiveBle
          .connectToDevice(id: deviceId)
          .listen((connectionState) {
        switch (connectionState.connectionState) {
          case DeviceConnectionState.connected:
            debugPrint("✅ Device $deviceId connected.");
            connectedDevices.add(deviceId);
            updateDeviceConnectionState(deviceId, true);
            break;

          case DeviceConnectionState.disconnected:
            debugPrint("⛓️ Device $deviceId disconnected.");
            updateDeviceConnectionState(deviceId, false);
            _connectionStreams[deviceId]?.cancel();
            _connectionStreams.remove(deviceId);
            connectedDevices.remove(deviceId);
            break;


          default:
            debugPrint("⏳ Unknown status for $deviceId.");
            break;
        }
      }, onError: (error) {
        debugPrint("❌ Error connecting to $deviceId: $error");
        _connectionStreams[deviceId]?.cancel();
        _connectionStreams.remove(deviceId);
      });
    } catch (e) {
      debugPrint("❌ Unexpected error connecting to $deviceId: $e");
    }

    return true;
  }
  void disconnectAllDevices() {
    debugPrint("🔴 Disconnecting all BLE devices...");

    final List<String> devicesToDisconnect = List.from(connectedDevices);

    for (final deviceId in devicesToDisconnect) {
      try {
        debugPrint("🔌 Disconnecting from $deviceId...");

        // 1️⃣ Cancel the connection subscription if it exists
        _connectionStreams[deviceId]?.cancel();
        _connectionStreams.remove(deviceId);

        // 2️⃣ Update device status as offline
        updateDeviceConnectionState(deviceId, false);

        // 3️⃣ Remove from the list of connected devices
        connectedDevices.remove(deviceId);
      } catch (e) {
        debugPrint("❌ Error closing connection with $deviceId: $e");
      }
    }

    // 4️⃣ Clean up global data structures
    targetDeviceIds.clear();
    connectedDevices.clear();
    _deviceConnectionStateControllers.forEach((_, controller) => controller.close());
    _deviceConnectionStateControllers.clear();

    // 5️⃣ Close the Device Update Stream
    _deviceUpdatesController.close();
    flutterReactiveBle.deinitialize();

    debugPrint("✅ All BLE connections have been closed and cleaned up.");
  }


  ///COMMUNICATION METHODS WITH MCIS

  /// Processes a connected device: initializes security and obtains information
  Future<void> processConnectedDevices(String deviceId) async {
    if (connectedDevices.isEmpty) {
      debugPrint("⚠️ No device connected. Aborting operations.");
      return;
    }
    try {
      // Initialize security using the CommandService
      await bleCommandService.initializeSecurity(deviceId);
      debugPrint("🔒--->>> Security initialization phase completed for $deviceId.");
      await _processDeviceInfo(deviceId);
    } catch (e) {
      debugPrint("❌--->>> Error processing device $deviceId: $e");
    }
  }

  Future<void> updateTariffIfTwoHours(String macAddress) async {
    try {
      // Get the current counters of the device
      final counters = await bleCommandService.getTariffCounters(macAddress)
          .timeout(const Duration(seconds: 15));
      final int currentTotal = counters['totalSeconds'] as int;
      final int remainingSeconds = counters['remainingSeconds'] as int;

      debugPrint("For $macAddress: totalCounter = $currentTotal s, remainingSeconds = $remainingSeconds s.");

      // If the remaining seconds are 7200 (2 hours) or less...
      if (remainingSeconds <= 7200) {
        // We calculate the new partial counter to “reload” until reaching the total.
        int newPartial = currentTotal - remainingSeconds;
        if (newPartial < 0) newPartial = 0; // For security

        debugPrint("Updating partial counter for $macAddress: newPartial = $newPartial s");

        // We call setTariffCounter, updating only the partial counter (writeTotal=0)
        bool result = await bleCommandService.setTariffCounter(
          macAddress,
          writeMode: 1, // Indicates that writing is executed
          writeTotal: 0, // The total is not modified, the obtained value is used (currentTotal)
          writePartial: 1, // The partial counter is updated
          tariff: 1, // With tariff (1)
          totalCounterSeconds: currentTotal, // The current total is used
          partialCounterSeconds: newPartial, // New partial value calculated
        );

        if (result) {
          debugPrint("Rate counter successfully updated for $macAddress.");
        } else {
          debugPrint("Error updating rate counter for $macAddress.");
        }
      } else {
        debugPrint("The remainingSeconds ($remainingSeconds s) is greater than 7200 s; no update is performed.");
      }
    } catch (e) {
      debugPrint("Error in updateTariffIfTwoHours for $macAddress: $e");
    }
  }




  /// Gets and processes general device information.
  Future<void> _processDeviceInfo(String macAddress) async {
    try {
      // FUN_INFO
      final deviceInfo = await bleCommandService.getDeviceInfo(macAddress)
          .timeout(const Duration(seconds: 3));
      final parsedInfo = bleCommandService.parseDeviceInfo(deviceInfo);
      debugPrint(parsedInfo);

      // FUN_GET_NAMEBT
      final nameBt = await bleCommandService.getBluetoothName(macAddress)
          .timeout(const Duration(seconds: 3));
      debugPrint("🅱️ Bluetooth Name ($macAddress): $nameBt");
      updateBluetoothName(macAddress, nameBt.isNotEmpty ? nameBt : "Not available");

      // FUN_GET_PARAMBAT
      final batteryParameters = await bleCommandService.getBatteryParameters(macAddress)
          .timeout(const Duration(seconds: 3));
      final parsedBattery = bleCommandService.parseBatteryParameters(batteryParameters);
      debugPrint(parsedBattery);
      updateBatteryStatus(macAddress, batteryParameters['batteryStatusRaw'] ?? -1);

      // FUN_GET_COUNTER
      final counters = await bleCommandService.getTariffCounters(macAddress)
          .timeout(const Duration(seconds: 3));
      final parsedCounters = bleCommandService.parseTariffCounters(counters);
      debugPrint(parsedCounters);

      // Check if the remaining time is equal to 2 hours and update the rate if applicable.
      await updateTariffIfTwoHours(macAddress);

    } catch (e) {
      debugPrint("❌ Error processing general information for $macAddress: $e");
    }
  }
}