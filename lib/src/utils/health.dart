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
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.WORKOUT
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
    } else {
      authorized = true;
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

  Future<int> fetchStepData([int day = 0]) async {
    int? steps;

    final now = DateTime.now().subtract(Duration(days: day));
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      steps = await health.getTotalStepsInInterval(midnight, now);
    } catch (error) {
      debugPrint("Caught exception in getTotalStepsInInterval: $error");
    }
    return steps ?? 0;
  }

  Future<int> fetchDistanceData([int day = 0]) async {
    double distance = 0;

    final now = DateTime.now().subtract(Duration(days: day));
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      List<HealthDataPoint> distanceDelta = await health.getHealthDataFromTypes(
          midnight, now, [HealthDataType.DISTANCE_DELTA]);
      for (HealthDataPoint entry in distanceDelta) {
        distance += (entry.value as NumericHealthValue).numericValue;
      }
    } catch (error) {
      debugPrint("Caught exception in getDistanceInInterval: $error");
    }
    return distance.round();
  }

  Future<int> fetchActiveEnergy([int day = 0]) async {
    double activeEnergy = 0;

    final now = DateTime.now().subtract(Duration(days: day));
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      List<HealthDataPoint> activeEnergyBurned =
          await health.getHealthDataFromTypes(midnight, now, [
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.BASAL_ENERGY_BURNED,
      ]);
      for (HealthDataPoint entry in activeEnergyBurned) {
        activeEnergy += (entry.value as NumericHealthValue).numericValue;
      }
    } catch (error) {
      debugPrint("Caught exception in getActiveEnergyBurnedInInterval: $error");
    }
    return activeEnergy.round();
  }

  Future<int> fetchSleepData([int day = 0]) async {
    int sleepMinutes = 0;

    final now = DateTime.now().subtract(Duration(days: day));
    final lastNoon = DateTime(now.year, now.month, now.day, 12)
        .subtract(const Duration(days: 1));
    final nextNoon = lastNoon.add(const Duration(days: 1));

    try {
      List<HealthDataPoint> sleeps =
          await health.getHealthDataFromTypes(lastNoon, nextNoon, [
        HealthDataType.SLEEP_SESSION,
      ]);
      for (HealthDataPoint entry in sleeps) {
        sleepMinutes +=
            (entry.value as NumericHealthValue).numericValue.round();
      }
    } catch (error) {
      debugPrint("Caught exception in getSleepInInterval: $error");
    }
    return sleepMinutes;
  }

  Future<int> fetchExerciseMinutes([int day = 0]) async {
    int exerciseMinutes = 0;

    final now = DateTime.now().subtract(Duration(days: day));
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      List<HealthDataPoint> exercise = await health
          .getHealthDataFromTypes(midnight, now, [HealthDataType.WORKOUT]);
      for (HealthDataPoint entry in exercise) {
        exerciseMinutes +=
            (entry.value as NumericHealthValue).numericValue.round();
      }
    } catch (error) {
      debugPrint("Caught exception in getExerciseTimeInInterval: $error");
    }
    return exerciseMinutes;
  }

  Future<int> fetchAvgHeartRate([int day = 0]) async {
    int avgHeartRate = 0;

    final now = DateTime.now().subtract(Duration(days: day));
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      List<HealthDataPoint> heartRate = await health
          .getHealthDataFromTypes(midnight, now, [HealthDataType.HEART_RATE]);
      for (HealthDataPoint entry in heartRate) {
        avgHeartRate +=
            (entry.value as NumericHealthValue).numericValue.round();
      }
      if (heartRate.isNotEmpty) {
        avgHeartRate = avgHeartRate ~/ heartRate.length;
      }
    } catch (error) {
      debugPrint("Caught exception in getHeartRateInInterval: $error");
    }
    return avgHeartRate;
  }

  Future<List<Map<String, dynamic>>> fetchDaysData(int days) async {
    List<Map<String, dynamic>> result = [];
    for (int i = 0; i < days; i++) {
      final before = DateTime.now().subtract(Duration(days: i));
      final steps = await fetchStepData(i);
      final distance = await fetchDistanceData(i);
      final activeEnergy = await fetchActiveEnergy(i);
      final sleep = await fetchSleepData(i);
      final exercise = await fetchExerciseMinutes(i);
      final heartRate = await fetchAvgHeartRate(i);
      result.add({
        "steps": steps,
        "distance": distance,
        "activeEnergy": activeEnergy,
        "sleep": sleep,
        "exercise": exercise,
        "heartRate": heartRate,
        "date": before
      });
    }
    return result;
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
