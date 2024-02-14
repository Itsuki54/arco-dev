import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:arco_dev/src/lib/bluetooth_controller.dart';
import 'package:ble_peripheral/ble_peripheral.dart' as BP;

class BluetoothTest extends StatefulWidget {
  BluetoothTest({Key? key}) : super(key: key);

  @override
  _BluetoothTestState createState() => _BluetoothTestState();
}

class _BluetoothTestState extends State<BluetoothTest> {
  Stream<List<ScanResult>>? scanResults;
  String serviceArco = "FA2DBDC2-409A-4DD3-95F6-698758FBBB0B";
  String characteristicArco = "20FF1B73-4807-466E-971B-E4CA982055D3";
  BluetoothController bluetoothController = BluetoothController();

  Future<void> startScan() async {
    if (await FlutterBluePlus.isSupported) {
      await bluetoothController.requestPermission();
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }
      await bluetoothController.scanDevices();
    } else {
      debugPrint('Bluetooth is not supported');
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-';
    final random = Random.secure();
    final randomStr =
        List.generate(length, (_) => charset[random.nextInt(charset.length)])
            .join();
    return randomStr;
  }

  Uint8List stringToBytes(String str) {
    final Uint8List uint8list = Uint8List.fromList(str.codeUnits);
    return uint8list;
  }

  String bytesToString(Uint8List bytes) {
    final String str = String.fromCharCodes(bytes);
    return str;
  }

  Future<void> initBle() async {
    bluetoothController.serviceUuids = [serviceArco, characteristicArco];
    await BP.BlePeripheral.initialize();
    await BP.BlePeripheral.addService(
        BP.BleService(uuid: serviceArco, primary: true, characteristics: [
      BP.BleCharacteristic(
          uuid: characteristicArco,
          properties: [
            BP.CharacteristicProperties.read.index,
            BP.CharacteristicProperties.notify.index
          ],
          value: stringToBytes('N7B3bek9a8WL9lYXMJhh'),
          permissions: [
            BP.AttributePermissions.readable.index,
          ])
    ]));
  }

  Future<void> startAdvertising() async {
    await BP.BlePeripheral.startAdvertising(
      services: [serviceArco],
      localName: "ARCO-${generateNonce(4)}",
    );
  }

  Future<void> stopAdvertising() async {
    await BP.BlePeripheral.stopAdvertising();
  }

  Future<String?> connectAndRead(BluetoothDevice device) async {
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == serviceArco) {
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        for (var characteristic in characteristics) {
          if (characteristic.uuid.toString() == characteristicArco) {
            List<int> c = await characteristic.read();
            debugPrint('Read: ${bytesToString(Uint8List.fromList(c))}');
            return bytesToString(Uint8List.fromList(c));
          }
        }
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    initBle().then((value) {
      startAdvertising().then(
        (value) {
          startScan();
        },
      );
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
    bool? isAdvertising = await BP.BlePeripheral.isAdvertising();
    debugPrint('Is advertising: $isAdvertising');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Test'),
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: bluetoothController.scanResults,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final List<ScanResult> scanResults = snapshot.data!;
            connectAndRead(scanResults.first.device);
          }
          return const Center(
              child: Column(
            children: [
              Icon(Icons.bluetooth_searching, size: 100),
              SizedBox(height: 16),
              Text('Searching for devices...')
            ],
          ));
        },
      ),
    );
  }
}
