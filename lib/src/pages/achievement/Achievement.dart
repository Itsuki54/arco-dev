//tamplate
import 'package:arco_dev/src/utils/database.dart';
import 'package:flutter/material.dart';

class Achievement extends StatefulWidget {
  const Achievement({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<Achievement> createState() => _AchievementState();
}

class _AchievementState extends State<Achievement> {
  Database db = Database();
  bool isWalk = true;
  bool isDistance = true;
  bool isSleep = true;

  int sumSleep = 0;
  int sumWalk = 0;
  int sumDistance = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('達成'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.workspace_premium, size: 40),
                      Text('世界ランク${}', style: TextStyle(fontSize: 24))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    setState(
                      () => isWalk = !isWalk,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: isWalk
                        ? [
                            Icon(Icons.directions_walk, size: 44),
                            Text("累計歩数", style: TextStyle(fontSize: 24))
                          ]
                        : [
                            Icon(Icons.directions_walk, size: 44),
                            Text('${sumWalk}歩', style: TextStyle(fontSize: 24))
                          ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    setState(
                      () => isDistance = !isDistance,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: isDistance
                        ? [
                            Icon(Icons.directions_walk, size: 44),
                            Text("累計距離", style: TextStyle(fontSize: 24))
                          ]
                        : [
                            Icon(Icons.directions_walk, size: 44),
                            Text('${sumDistance}km',
                                style: TextStyle(fontSize: 24))
                          ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    setState(
                      () => isSleep = !isSleep,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: isSleep
                          ? [
                              Icon(Icons.hotel, size: 44),
                              Text("累計睡眠時間", style: TextStyle(fontSize: 24))
                            ]
                          : [
                              Icon(Icons.hotel, size: 44),
                              Text('${sumSleep}時間',
                                  style: TextStyle(fontSize: 24))
                            ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
