import 'package:flutter/material.dart';

class HealthViewPage extends StatefulWidget {
  const HealthViewPage({super.key});

  @override
  State<HealthViewPage> createState() => _HealthViewPage();
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
          SizedBox(
            width: 180,
            height: 170,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {},
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.shade700,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(Icons.directions_walk,
                              size: 34, color: Colors.white),
                        ),
                        Text("歩行距離",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue.shade700))
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    Text("10.2km",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue.shade700)),
                    const Expanded(child: SizedBox()),
                    const SizedBox(height: 18),
                  ],
                )),
          )
        ],
      )),
    );
  }
}
