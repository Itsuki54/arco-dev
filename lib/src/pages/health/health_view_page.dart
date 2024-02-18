import 'package:arco_dev/src/utils/colors.dart';
import 'package:flutter/material.dart';

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
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: iconImage,
                      ),
                      const SizedBox(width: 4),
                      Text(title,
                          style: TextStyle(
                              fontSize: 22,
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
  @override
  Widget build(BuildContext context) {
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
