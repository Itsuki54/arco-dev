import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ble_peripheral/ble_peripheral.dart' as bp;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BluetoothTest extends StatefulWidget {
  BluetoothTest({Key? key}) : super(key: key);

  @override
  _BluetoothTestState createState() => _BluetoothTestState();
}

class _BluetoothTestState extends State<BluetoothTest> {
  String serviceArco = "FA2DBDC2-409A-4DD3-95F6-698758FCCC0B";
  String characteristicArco = "20FF0003-4807-466E-971B-E4CA982055D3";
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  late StreamSubscription<ConnectionStateUpdate> _connection;
  String advertisingError = '';
  String _uid = '';
  final List<String> _connectedDevices = [];

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-';
    final random = Random.secure();
    final randomStr =
        List.generate(length, (_) => charset[random.nextInt(charset.length)])
            .join();
    return randomStr;
  }

  Future<void> initBle() async {
    await bp.BlePeripheral.initialize();
    await bp.BlePeripheral.addService(
        bp.BleService(uuid: serviceArco, primary: true, characteristics: [
      bp.BleCharacteristic(
          uuid: characteristicArco,
          properties: [
            bp.CharacteristicProperties.read.index,
          ],
          value: null,
          permissions: [
            bp.AttributePermissions.readable.index,
          ])
    ]));
    bp.BlePeripheral.setReadRequestCallback(
        (deviceId, characteristicId, offset, value) {
      // ユーザーIDを取得
      return bp.ReadRequestResult(value: utf8.encode("N7B3bek9a8WL9lYXMJhh"));
    });
    bp.BlePeripheral.setAdvertingStartedCallback((String? error) {
      if (error != null) {
        print("AdvertisingFailed: $error");
        setState(() {
          advertisingError = error;
        });
      }
    });
  }

  Future<void> startAdvertising() async {
    await bp.BlePeripheral.startAdvertising(
      services: [serviceArco],
      localName: "arco${generateNonce(3)}",
    );
  }

  Future<void> stopAdvertising() async {
    await bp.BlePeripheral.stopAdvertising();
  }

  Future<void> readUid(DiscoveredDevice device) async {
    final characteristic = QualifiedCharacteristic(
        characteristicId: Uuid.parse(characteristicArco),
        serviceId: Uuid.parse(serviceArco),
        deviceId: device.id);
    final response = await _ble.readCharacteristic(characteristic);
    if (response.isEmpty) {
      debugPrint('Failed to read characteristic');
    } else {
      final value = utf8.decode(response);
      debugPrint('Read value: $value');
      setState(() {
        _uid = value;
      });
    }
    await disconnectFromDevice();
  }

  Future<void> searchForDevices() async {
    await for (final scanResult in _ble.scanForDevices(
        withServices: [Uuid.parse(serviceArco)],
        scanMode: ScanMode.lowLatency)) {
      if (!_connectedDevices.contains(scanResult.id)) {
        debugPrint('Found device: ${scanResult.name}');
        _connectedDevices.add(scanResult.id);
        connectToDevice(scanResult);
      }
    }
  }

  Future<void> connectToDevice(DiscoveredDevice device) async {
    _connection = _ble
        .connectToDevice(
            id: device.id,
            servicesWithCharacteristicsToDiscover: {
              Uuid.parse(serviceArco): [Uuid.parse(characteristicArco)]
            },
            connectionTimeout: const Duration(seconds: 5))
        .listen((event) {
      print("Connection state: ${event.connectionState}");
      if (event.connectionState == DeviceConnectionState.connecting) {
        debugPrint('Connected to device');
        readUid(device);
      }
    });
  }

  Future<void> disconnectFromDevice() async {
    debugPrint('Disconnecting from device');
    await _connection.cancel();
  }

  @override
  void initState() {
    super.initState();
    initBle().then((value) {
      if (advertisingError.isNotEmpty) {
        debugPrint('Advertising error: $advertisingError');
      } else {
        startAdvertising();
        searchForDevices();
      }
    });
  }

  @override
  void dispose() {
    stopAdvertising().then(
      (value) {
        super.dispose();
      },
    );
  }

  Future<void> checkAdvertising() async {
    bool? isAdvertising = await bp.BlePeripheral.isAdvertising();
    debugPrint('Is advertising: $isAdvertising');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Test'),
      ),
      body: _uid != ""
          ? Center(child: Text('UID: $_uid'))
          : const Center(
              child: Column(
              children: [
                Icon(Icons.bluetooth, size: 100),
                Text('Scanning for devices...'),
              ],
            )),
    );
  }
}
