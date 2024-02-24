//tamplate
import 'package:arco_dev/src/pages/achievement/ranking.dart';
import 'package:arco_dev/src/utils/database.dart';
import 'package:flutter/material.dart';

import '../../components/common/child_appbar.dart';

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

  int sumLogin = 0;
  int firstPlay = 0;
  int sumBattle = 0;
  int sumWin = 0;
  int sumGetItem = 0;
  int sumGetWeapon = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChildAppBar(
          title: "統計", icon: Icon(Icons.show_chart, size: 40)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 240,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        Icon(Icons.login, size: 24),
                        Text('初めてプレイした日${firstPlay}日',
                            style: TextStyle(fontSize: 20))
                      ]),
                      Row(children: [
                        Icon(Icons.login, size: 24),
                        Text('ログイン${sumLogin}日', style: TextStyle(fontSize: 20))
                      ]),
                      Row(children: [
                        Icon(Icons.emoji_events, size: 24),
                        Text('バトル${sumBattle}回', style: TextStyle(fontSize: 20))
                      ]),
                      Row(children: [
                        Icon(Icons.emoji_events, size: 24),
                        Text('勝利${sumWin}回', style: TextStyle(fontSize: 20))
                      ]),
                      Row(children: [
                        Icon(Icons.emoji_events, size: 24),
                        Text('アイテム${sumGetItem}個',
                            style: TextStyle(fontSize: 20))
                      ]),
                      Row(children: [
                        Icon(Icons.emoji_events, size: 24),
                        Text('武器${sumGetWeapon}個',
                            style: TextStyle(fontSize: 20))
                      ]),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 80,
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
                height: 80,
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
                height: 80,
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
              SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Ranking(uid: widget.uid)));
                    },
                    child: const Icon(Icons.workspace_premium, size: 40),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
