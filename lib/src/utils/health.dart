import 'dart:async';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
}

class HealthData {
  static final types = [
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
    HealthDataType.DISTANCE_DELTA,
  ];

  List<HealthDataAccess> permissions =
      types.map((e) => HealthDataAccess.READ).toList();
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  Future<bool> authorize() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);
    bool authorized = false;
    if (!hasPermissions!) {
      try {
        authorized =
            await health.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        debugPrint("Exception in authorize: $error");
      }
    }
    return authorized;
  }

  Future<List> fetchData(int take, int days) async {
    List<HealthDataPoint> healthDataList = [];
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: days));
    healthDataList.clear();
    try {
      List<HealthDataPoint> healthData =
          await health.getHealthDataFromTypes(yesterday, now, types);
      healthDataList.addAll(healthData.take(take));
    } catch (error) {
      debugPrint("Exception in getHealthDataFromTypes: $error");
    }
    healthDataList = HealthFactory.removeDuplicates(healthDataList);
    return healthDataList;
  }

  Future<int> fetchStepData() async {
    int? steps;

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool stepsPermission =
        await health.hasPermissions([HealthDataType.STEPS]) ?? false;
    if (!stepsPermission) {
      stepsPermission =
          await health.requestAuthorization([HealthDataType.STEPS]);
    }

    if (stepsPermission) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        debugPrint("Caught exception in getTotalStepsInInterval: $error");
      }
      return steps ?? 0;
    } else {
      debugPrint("Authorization not granted - error in authorization");
      return 0;
    }
  }

  Stream<AppState> getState() async* {
    yield AppState.FETCHING_DATA;
    bool authorized = await authorize();
    if (authorized) {
      yield AppState.AUTHORIZED;
    } else {
      yield AppState.AUTH_NOT_GRANTED;
    }
  }
}
