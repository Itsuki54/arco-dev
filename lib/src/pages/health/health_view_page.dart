import 'package:arco_dev/src/utils/colors.dart';
import 'package:arco_dev/src/utils/health.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthViewPage extends StatefulWidget {
  const HealthViewPage({super.key});

  @override
  State<HealthViewPage> createState() => _HealthViewPage();
}

class HealthContentButton extends StatelessWidget {
  const HealthContentButton({
    super.key,
    required this.title,
    required this.text,
    required this.iconImage,
    required this.color,
    required this.onPressed,
  });

  final Color color;
  final dynamic iconImage;
  final String title;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      onPressed: onPressed,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: iconImage,
                  ),
                  const SizedBox(width: 4),
                  Text(title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color))
                ],
              ),
              const SizedBox(height: 20),
              Text(
                text,
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          )),
    );
  }
}

class _HealthViewPage extends State<HealthViewPage> {
  int touchedIndex = -1;
  int step = 0;
  String exerciseStr = "0 分";
  String energyStr = "0 kcal";
  int energy = 0;
  int heartRate = 0;
  String sleepStr = "";
  String distanceStr = "0 m";
  final healthData = HealthData();

  @override
  void initState() {
    super.initState();
    healthData.authorize().then((bool authorized) {
      if (authorized) {
        healthData.fetchStepData().then((int steps) {
          setState(() {
            step = steps;
          });
        });
        healthData.fetchDistanceData().then((int distance) {
          setState(() {
            if (distance >= 1000) {
              distanceStr = "${(distance / 1000).toStringAsFixed(1)} km";
            } else {
              distanceStr = "$distance m";
            }
          });
        });
        healthData.fetchActiveEnergy().then((int activeEnergy) {
          setState(() {
            energy = activeEnergy;
            energyStr = "${activeEnergy ~/ 1000} kcal";
          });
        });
        healthData.fetchSleepData().then((int sleep) {
          setState(() {
            if (sleep >= 60) {
              sleep = sleep ~/ 60;
              sleepStr = "$sleep 時間";
            } else {
              sleepStr = "$sleep 分";
            }
          });
        });
        healthData.fetchExerciseMinutes().then((int exercise) {
          setState(() {
            if (exercise >= 60) {
              exercise = exercise ~/ 60;
              exerciseStr = "$exercise 時間";
            } else {
              exerciseStr = "$exercise 分";
            }
          });
        });
        healthData.fetchAvgHeartRate().then((int heartRate) {
          setState(() {
            this.heartRate = heartRate;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> calorieSections() {
      return List.generate(2, (i) {
        double fontSize = 24;
        double radius = 20;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: AppColors.orange,
              // max 1500 kcal
              value: energy * 0.001 / 15,
              title: "",
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          case 1:
            return PieChartSectionData(
              color: AppColors.lightOrange,
              value: 100 - energy * 0.001 / 15,
              radius: radius,
              title: "",
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          default:
            throw Error();
        }
      });
    }

    List<PieChartSectionData> stepSections() {
      return List.generate(2, (i) {
        double fontSize = 24.0;
        double radius = 20.0;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: AppColors.blue,
              value: step * 0.01,
              title: "",
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          case 1:
            return PieChartSectionData(
              color: AppColors.lightBlue,
              value: 100 - step * 0.01,
              radius: radius,
              title: "",
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          default:
            throw Error();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "健康",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          )),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 18),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  width: 300,
                  height: 300,
                  margin: const EdgeInsets.all(5),
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 98,
                      sections: stepSections(),
                    ),
                  )),
              Container(
                  width: 300,
                  height: 300,
                  margin: const EdgeInsets.all(5),
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 130,
                      sections: calorieSections(),
                    ),
                  )),
              Column(
                children: [
                  Text("歩数",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blue)),
                  Text("$step歩",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blue)),
                  Text("消費熱量",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.orange)),
                  Text(energyStr,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.orange)),
                ],
              )
            ],
          ),
          const SizedBox(height: 32),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.25,
                shrinkWrap: true,
                children: [
                  HealthContentButton(
                    color: AppColors.blue,
                    iconImage: const Icon(Icons.directions_walk,
                        size: 28, color: Colors.white),
                    title: "移動距離",
                    text: distanceStr,
                    onPressed: () {},
                  ),
                  HealthContentButton(
                    color: AppColors.red,
                    iconImage: const Icon(Icons.nights_stay,
                        size: 28, color: Colors.white),
                    title: "睡眠時間",
                    text: sleepStr,
                    onPressed: () {},
                  ),
                  HealthContentButton(
                    color: AppColors.orange,
                    iconImage: const Icon(Icons.sports_football,
                        size: 28, color: Colors.white),
                    title: "運動時間",
                    text: exerciseStr,
                    onPressed: () {},
                  ),
                  HealthContentButton(
                    color: AppColors.green,
                    iconImage: const Icon(Icons.monitor_heart,
                        size: 28, color: Colors.white),
                    title: "心拍数",
                    text: "$heartRate bpm",
                    onPressed: () {},
                  ),
                ],
              )),
        ],
      )),
    );
  }
}
