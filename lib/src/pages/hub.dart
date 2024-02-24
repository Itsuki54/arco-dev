import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:arco_dev/src/pages/home.dart';
import 'package:arco_dev/src/utils/auto_battle.dart';
import 'package:arco_dev/src/utils/database.dart';
import 'package:ble_peripheral/ble_peripheral.dart' as bp;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

import '../utils/daily_exp_health.dart';
import './backpack/backpack.dart';
import './map/map.dart';

class Hub extends StatefulWidget {
  const Hub({super.key, required this.uid});

  final String uid;

  @override
  State<Hub> createState() => _Hub();
}

class _Hub extends State<Hub> {
  List<Widget> _pages() => [
        MapPage(uid: widget.uid),
        HomePage(uid: widget.uid),
        BackpackPage(
          uid: widget.uid,
          battleResults: battleResults,
        ),
      ];
  int pageIndex = 1;
  String serviceArco = "FA2DBDC2-409A-4DD3-95F6-698758FCCC0B";
  String characteristicArco = "20FF0003-4807-466E-971B-E4CA982055D3";
  //final FlutterReactiveBle _ble = FlutterReactiveBle();
  //late StreamSubscription<ConnectionStateUpdate> _connection;
  String advertisingError = '';
  List<String> connectedUids = [];
  List<String> battledUids = [];
  List<Map<String, dynamic>> battleResults = [];
  final List<String> _connectedDevices = [];
  final messaging = FirebaseMessaging.instance;
  Database db = Database();
  int exp = 0;
  bool connectLock = false;

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
    await messaging.requestPermission(
        announcement: true, badge: true, sound: true);
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
      return bp.ReadRequestResult(value: utf8.encode(widget.uid));
    });
    bp.BlePeripheral.setAdvertingStartedCallback((String? error) {
      if (error != null) {
        debugPrint("AdvertisingFailed: $error");
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
    debugPrint('Advertising started');
  }

  Future<void> stopAdvertising() async {
    try {
      await bp.BlePeripheral.stopAdvertising();
    } catch (e) {
      debugPrint('Failed to stop advertising: $e');
    }
  }

  Future<void> readUid(BluetoothDevice device) async {
    try {
      /*final characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse(characteristicArco),
          serviceId: Uuid.parse(serviceArco),
          deviceId: device.id);
      debugPrint(characteristic.toString());
      final response = await _ble.readCharacteristic(characteristic);
      debugPrint('Read characteristic: $response');
      if (response.isEmpty) {
        debugPrint('Failed to read characteristic');
      } else {
        final value = utf8.decode(response);
        debugPrint('Read characteristic: $value');
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
          battleResults[value]["opponent"] = autoBattle.opponent;
          battleResults[value]["endTime"] = autoBattle.endTime;
        });
      }*/
      final services = await device.discoverServices();
      final service = services.firstWhere(
          (service) => service.uuid == Guid(serviceArco),
          orElse: () => throw Exception('Service not found'));
      final characteristics = service.characteristics;
      for (BluetoothCharacteristic characteristic in characteristics) {
        if (characteristic.properties.read) {
          if (characteristic.uuid == Guid(characteristicArco)) {
            final value = await characteristic.read();
            final uid = utf8.decode(value);
            setState(() {
              connectedUids.add(uid);
            });
          }
        }
      }

      await disconnectFromDevice(device);
    } catch (e) {
      debugPrint('Failed to read characteristic: $e');
      await disconnectFromDevice(device);
    }

    connectLock = false;
    if (connectedUids.isNotEmpty) {
      for (int i = 0; i < connectedUids.length; i++) {
        if (!battledUids.contains(connectedUids[i])) {
          AutoBattle autoBattle = AutoBattle(widget.uid, connectedUids[i]);
          bool res = await autoBattle.start();
          setState(() {
            battledUids.add(connectedUids[i]);
            battleResults.add({
              "result": autoBattle.finalResult,
              "exp": autoBattle.finalExp,
              "win": res,
              "party": autoBattle.finalParties,
              "name": autoBattle.name,
              "opponent": autoBattle.opponent,
              "endTime": autoBattle.endTime
            });
          });
        }
      }
    }
  }

  Future<void> searchForDevices() async {
    /*await for (final scanResult in _ble.scanForDevices(
        withServices: [Uuid.parse(serviceArco)],
        scanMode: ScanMode.lowLatency)) {
      if (!_connectedDevices.contains(scanResult.id)) {
        debugPrint('Found device: ${scanResult.name}');
        _connectedDevices.add(scanResult.id);
        if (!connectLock) connectToDevice(scanResult);
      }
    }*/
    FlutterBluePlus.onScanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (!_connectedDevices.contains(result.advertisementData.advName)) {
          debugPrint('Found device: ${result.advertisementData.advName}');
          _connectedDevices.add(result.advertisementData.advName);
          if (!connectLock) connectToDevice(result.device);
        }
      }
    }, onError: (Object error) {
      debugPrint('Error: $error');
    });
    await FlutterBluePlus.startScan(
        withServices: [Guid(serviceArco)], timeout: const Duration(seconds: 2));
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    /*_connection = _ble
        .connectToDevice(
            id: device.id,
            servicesWithCharacteristicsToDiscover: {
              Uuid.parse(serviceArco): [Uuid.parse(characteristicArco)],
            },
            connectionTimeout: const Duration(seconds: 2))
        .listen((event) {
      if (connectLock) return;
      connectLock = true;
      if (event.connectionState == DeviceConnectionState.connected) {
        debugPrint('Connected to device');
        readUid(device);
      }
    });*/
    try {
      await device.connect();
      debugPrint('Connected to device');
      readUid(device);
    } catch (e) {
      debugPrint('Failed to connect to device: $e');
      connectLock = false;
    }
  }

  Future<void> disconnectFromDevice(BluetoothDevice device) async {
    debugPrint('Disconnecting from device');
    //await _connection.cancel();
    try {
      await device.disconnect();
    } catch (e) {
      debugPrint('Failed to disconnect from device: $e');
    }
    connectLock = false;
  }

  Future<void> lastLogin() async {
    final lastLogin = await db.usersCollection().findById(widget.uid);
    if (lastLogin.containsKey("lastLogin")) {
      final lastLoginTime = lastLogin["lastLogin"];
      final now = DateTime.now();
      final diff = DateTime(now.year, now.month, now.day)
          .difference(lastLoginTime.toDate())
          .inDays;
      if (diff == 1) {
        await db.usersCollection().update(widget.uid, {
          "lastLogin": DateTime(now.year, now.month, now.day),
          "loginCount": FieldValue.increment(1)
        });
      } else if (diff > 1) {
        await db.usersCollection().update(widget.uid, {
          "lastLogin": DateTime(now.year, now.month, now.day),
          "loginCount": 1
        });
      }
    } else {
      final now = DateTime.now();
      await db.usersCollection().update(widget.uid, {
        "lastLogin": DateTime(now.year, now.month, now.day),
        "loginCount": 1
      });
    }
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
          } else {
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
    Future(() async {
      int lastDay = DateTime.now().day;
      final user = await db.usersCollection().findById(widget.uid);
      exp = user["exp"] != null ? (user["exp"] as double).toInt() : 0;
      Timer.periodic(const Duration(hours: 24), (Timer t) async {
        exp += (await HealthExp().getExp(lastDay)).toInt();
        db.usersCollection().update(widget.uid, {"exp": exp});
      });
      setState(() {
        lastDay = DateTime.now().day;
      });
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
