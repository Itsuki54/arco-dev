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
    return Container(
        margin: const EdgeInsets.all(8),
        child: SizedBox(
          width: 180,
          height: 160,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: onPressed,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(50),
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
                  const SizedBox(height: 32),
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                ],
              )),
        ));
  }
}

class _HealthViewPage extends State<HealthViewPage> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> stepSections() {
      return List.generate(2, (i) {
        final isTouched = false;
        final fontSize = isTouched ? 32.0 : 24.0;
        final radius = isTouched ? 40.0 : 30.0;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: AppColors.orange,
              value: 50,
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
              value: 10,
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

    List<PieChartSectionData> calorieSections() {
      return List.generate(2, (i) {
        //final isTouched = i == touchedIndex;
        final isTouched = false;
        final fontSize = isTouched ? 32.0 : 24.0;
        final radius = isTouched ? 40.0 : 30.0;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: AppColors.blue,
              value: 50,
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
              value: 10,
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
            "Health",
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
                      sections: calorieSections(),
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
                      sections: stepSections(),
                    ),
                  )),
              Column(
                children: [
                  Text("歩数",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  Text("7810歩",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightprimary)),
                  Text("消費熱量",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  Text("470kcal",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightprimary)),
                ],
              )
            ],
          ),
          const SizedBox(height: 32),
          Row(children: [
            HealthContentButton(
                onPressed: () {},
                title: "移動距離",
                text: "10.3km",
                iconImage: const Icon(Icons.directions_walk,
                    size: 34, color: Colors.white),
                color: AppColors.blue),
            HealthContentButton(
                onPressed: () {},
                title: "睡眠時間",
                text: "7.2h",
                iconImage: const Icon(Icons.local_hotel,
                    size: 34, color: Colors.white),
                color: AppColors.red),
          ]),
          Row(
            children: [
              HealthContentButton(
                  onPressed: () {},
                  title: "運動時間",
                  text: "2.3h",
                  iconImage: const Icon(Icons.directions_run,
                      size: 34, color: Colors.white),
                  color: AppColors.orange),
              HealthContentButton(
                  onPressed: () {},
                  title: "ストレス",
                  text: "Calm",
                  iconImage: const Icon(Icons.directions_walk,
                      size: 34, color: Colors.white),
                  color: AppColors.green),
            ],
          ),
        ],
      )),
    );
  }
}
