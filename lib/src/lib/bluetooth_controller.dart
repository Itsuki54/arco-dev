import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothController extends GetxController {
  List<String> _serviceUuids = [];
  Future<bool> requestPermission() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    if (Platform.isAndroid && androidInfo.version.sdkInt > 30) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise
      ].request();

      if (statuses[Permission.bluetoothScan] == PermissionStatus.granted &&
          statuses[Permission.bluetoothConnect] == PermissionStatus.granted &&
          statuses[Permission.bluetoothAdvertise] == PermissionStatus.granted) {
        return true;
      }
      return false;
    } else {
      await [
        Permission.bluetooth,
      ].request();
      if (await Permission.bluetooth.isGranted) {
        return true;
      }
      return false;
    }
  }

  set serviceUuids(List<String> uuids) {
    _serviceUuids = uuids;
  }

  Future scanDevices() async {
    if (_serviceUuids.isEmpty) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    } else {
      FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 5),
          withServices: [for (var uuid in _serviceUuids) Guid(uuid)]);
    }
  }

  // scan result stream
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  // connect to device
  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
  }
}
