import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:arco_dev/src/utils/auto_battle.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:ble_peripheral/ble_peripheral.dart' as bp;
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_svg/flutter_svg.dart';

import './backpack/backpack.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import './map/map.dart';
import 'package:arco_dev/src/pages/home.dart';

class Hub extends StatefulWidget {
  const Hub({super.key, required this.uid});

  final String uid;

  @override
  State<Hub> createState() => _Hub();
}

class _Hub extends State<Hub> {
  List<Widget> _pages() => [
        MapPage(),
        HomePage(uid: widget.uid),
        BackpackPage(
          uid: widget.uid,
          battleResults: battleResults,
        ),
      ];
  int pageIndex = 1;
  String serviceArco = "FA2DBDC2-409A-4DD3-95F6-698758FCCC0B";
  String characteristicArco = "20FF0003-4807-466E-971B-E4CA982055D3";
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  late StreamSubscription<ConnectionStateUpdate> _connection;
  String advertisingError = '';
  List<String> connectedUids = [];
  Map<String, dynamic> battleResults = {};
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

  Future<bool> get isGranted async {
    final status = await permission.Permission.location.status;
    switch (status) {
      case permission.PermissionStatus.granted:
      case permission.PermissionStatus.limited:
        return true;
      case permission.PermissionStatus.denied:
      case permission.PermissionStatus.permanentlyDenied:
      case permission.PermissionStatus.restricted:
        return false;
      default:
        return false;
    }
  }

  Future<bool> get isAlwaysGranted {
    return permission.Permission.locationAlways.isGranted;
  }

  Future<permission.PermissionStatus> whileRequest() async {
    final locationStatus = await permission.Permission.location.request();
    permission.PermissionStatus status;
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 30) {
      final bleStatus = await permission.Permission.bluetooth.request();
      status = locationStatus == permission.PermissionStatus.granted &&
              bleStatus == permission.PermissionStatus.granted
          ? permission.PermissionStatus.granted
          : permission.PermissionStatus.denied;
    } else {
      final bleAdvertiseStatus =
          await permission.Permission.bluetoothAdvertise.request();
      final bleConnectStatus =
          await permission.Permission.bluetoothConnect.request();
      final bleScanStatus = await permission.Permission.bluetoothScan.request();
      status = locationStatus == permission.PermissionStatus.granted &&
              bleAdvertiseStatus == permission.PermissionStatus.granted &&
              bleConnectStatus == permission.PermissionStatus.granted &&
              bleScanStatus == permission.PermissionStatus.granted
          ? permission.PermissionStatus.granted
          : permission.PermissionStatus.denied;
    }
    return status;
  }

  Future<LocationPermissionStatus> alwaysRequest() async {
    final status = await permission.Permission.locationAlways.request();
    switch (status) {
      case permission.PermissionStatus.granted:
        return LocationPermissionStatus.granted;
      default:
        return LocationPermissionStatus.denied;
    }
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
    try {
      await bp.BlePeripheral.stopAdvertising();
    } catch (e) {
      debugPrint('Failed to stop advertising: $e');
    }
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
      setState(() {
        connectedUids.add(value);
      });
      AutoBattle autoBattle = AutoBattle(widget.uid, value);
      bool res = await autoBattle.start();
      setState(() {
        battleResults[value]["result"] = autoBattle.finalResult;
        battleResults[value]["exp"] = autoBattle.finalExp;
        battleResults[value]["win"] = res;
        battleResults[value]["party"] = autoBattle.finalParties;
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
    whileRequest().then((permission.PermissionStatus status) {
      if (status == permission.PermissionStatus.granted) {
        isAlwaysGranted.then((bool isAlwaysGranted) {
          if (!isAlwaysGranted) {
            alwaysRequest().then((LocationPermissionStatus status) {
              if (status == LocationPermissionStatus.granted) {
                initBle().then((value) {
                  if (advertisingError.isNotEmpty) {
                    debugPrint('Advertising error: $advertisingError');
                  } else {
                    startAdvertising();
                    searchForDevices();
                  }
                });
              }
            });
          }
        });
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("位置情報 / Bluetoothの許可が必要です"),
                  content: const Text("設定画面から権限の許可をしてください"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))
                  ],
                ));
      }
    });
  }

  @override
  void dispose() {
    stopAdvertising();
    super.dispose();
  }

  Future<void> checkAdvertising() async {
    bool? isAdvertising = await bp.BlePeripheral.isAdvertising();
    debugPrint('Is advertising: $isAdvertising');
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages();
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: NavigationBar(
        destinations: <Widget>[
          const NavigationDestination(icon: Icon(Icons.map), label: "地図"),
          const NavigationDestination(icon: Icon(Icons.home), label: "ホーム"),
          NavigationDestination(
              icon: SvgPicture.asset("assets/images/swords.svg", width: 24),
              label: "戦闘"),
        ],
        selectedIndex: pageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
