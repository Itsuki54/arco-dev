import './health.dart';

class HealthExp {
  HealthData healthData = HealthData();
  Future<List<Map<String, dynamic>>> getHealthData(int lastDay) async {
    return await healthData.fetchDaysData(lastDay);
  }

  Future<int> getExp(lastDay) async {
    double exp = 0;
    final now = DateTime.now();
    var datas = await getHealthData(lastDay - now);
    for (var data in datas) {
      exp += data['steps'] * 0.01;
      exp += data['distance'] * 0.005;
      exp += data['activeEnergy'] * 0.5;
      exp += data['sleep'] * 10;
      exp += data['exercise'] * 0.5;
      exp += exp / (data['heartRate'] - 70).abs / 10;
    }
    return exp.round();
  }
}
