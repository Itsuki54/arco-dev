import 'dart:async';

import 'package:arco_dev/src/utils/colors.dart';
import 'package:arco_dev/src/utils/database.dart';
import 'package:arco_dev/src/utils/health.dart';
import 'package:flutter/material.dart';
// components
import '../../components/button/filter_button.dart';
import '../../components/quest/quest_content.dart';
// structs
import '../../structs/quest.dart';
import '../../components/common/exp_bar.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  // Filterの状態
  /*
    None,
    未完了,
    受取り,
  */
  String filterState = "None";
  Database db = Database();
  HealthData healthData = HealthData();

  // 表示用
  int totalExp = 100;
  int currentExp = 30;
  int level = 1;

  // Questデータ
  List<Quest> quests = [];

  // 表示用
  late List<Quest> displayedDailyQuests = quests;
  late List<Quest> displayedWeeklyQuests = quests;
  late List<Quest> displayedAchievedQuests = quests;

  List<List<Map<String, dynamic>>> healthDataList = [];
  Future<bool> yesterdayData() async {
    final yesterdayData = await healthData.fetchDaysData(1);
    if (yesterdayData.isEmpty) {
      return false;
    }
    healthDataList.add(yesterdayData);
    return true;
  }

  Future<bool> checkCondition(Quest quest) async {
    final dailyHealthData = healthDataList[healthDataList.length - 1];
    final weeklyHealthData = healthDataList
        .sublist(healthDataList.length - 7, healthDataList.length)
        .expand((element) => element)
        .toList();
    List<bool> results = [];
    for (var condition in quest.condition) {
      debugPrint(condition);
      final [field, operand, value] = condition.split(" ");
      // field: calorie | steps | winCount | loginDay | sleep
      // operand: >=
      // value: int
      if (field == "loginDay") {
        if (operand == ">=") {
          final loginCount =
              (await db.usersCollection().findById(widget.uid))['loginCount'] ??
                  0;
          if (loginCount >= int.parse(value)) {
            results.add(true);
            continue;
          }
        }
      }
      if (field == "winCount") {
        if (operand == ">=") {
          final winCount =
              (await db.usersCollection().findById(widget.uid))['winCount'] ??
                  0;
          if (winCount >= int.parse(value)) {
            results.add(true);
            continue;
          }
        }
      }
      if (quest.frequency == "daily") {
        if (field == "calorie") {
          if (operand == ">=") {
            if (dailyHealthData.map(
                  (e) {
                    return e["activeEnergy"];
                  },
                ).reduce((value, element) {
                  return value + element;
                }) >=
                int.parse(value)) {
              results.add(true);
            }
          }
        } else if (field == "steps") {
          if (operand == ">=") {
            if (dailyHealthData.map(
                  (e) {
                    return e["steps"];
                  },
                ).reduce((value, element) {
                  return value + element;
                }) >=
                int.parse(value)) {
              results.add(true);
            }
          }
        } else if (field == "sleep") {
          if (operand == ">=") {
            if (dailyHealthData.map(
                  (e) {
                    return e["sleep"];
                  },
                ).reduce((value, element) {
                  return value + element;
                }) >=
                int.parse(value)) {
              results.add(true);
            }
          }
        }
      } else if (quest.frequency == "weekly") {
        if (field == "calorie") {
          if (operand == ">=") {
            if (weeklyHealthData.map(
                  (e) {
                    return e["activeEnergy"];
                  },
                ).reduce((value, element) {
                  return value + element;
                }) >=
                int.parse(value)) {
              results.add(true);
            }
          }
        } else if (field == "steps") {
          if (operand == ">=") {
            if (weeklyHealthData.map(
                  (e) {
                    return e["steps"];
                  },
                ).reduce((value, element) {
                  return value + element;
                }) >=
                int.parse(value)) {
              results.add(true);
            }
          }
        } else if (field == "sleep") {
          if (operand == ">=") {
            if (weeklyHealthData.map(
                  (e) {
                    return e["sleep"];
                  },
                ).reduce((value, element) {
                  return value + element;
                }) >=
                int.parse(value)) {
              results.add(true);
            }
          }
        }
      }
    }
    return results.every((element) => element == true);
  }

  // フィルターに応じて表示DailyQuestのソートを行う
  void sortDailyQuests() {
    setState(() {
      if (filterState != "None") {
        displayedDailyQuests = quests
            .where((Quest quest) =>
                (quest.state == filterState && quest.frequency == "daily"))
            .toList();
        //(quest.state == filterState)).toList();
      } else {
        List<Quest> acceptedQuests, unfinishedQuests, finishedQuests;
        acceptedQuests = quests
            .where((Quest quest) =>
                (quest.state == "受取り" && quest.frequency == "daily"))
            .toList();
        unfinishedQuests = quests
            .where((Quest quest) =>
                (quest.state == "未完了" && quest.frequency == "daily"))
            .toList();
        finishedQuests = quests
            .where((Quest quest) =>
                (quest.state == "完了" && quest.frequency == "daily"))
            .toList();
        displayedDailyQuests = [];
        displayedDailyQuests.addAll(acceptedQuests);
        displayedDailyQuests.addAll(unfinishedQuests);
        displayedDailyQuests.addAll(finishedQuests);
      }
    });
  }

  // フィルターに応じて表示WeeklyQuestのソートを行う
  void sortWeeklyQuests() {
    setState(() {
      if (filterState != "None") {
        displayedWeeklyQuests = quests
            .where((Quest quest) =>
                (quest.state == filterState && quest.frequency == "weekly"))
            .toList();
        //(quest.state == filterState)).toList();
      } else {
        List<Quest> acceptedQuests, unfinishedQuests, finishedQuests;
        acceptedQuests = quests
            .where((Quest quest) =>
                (quest.state == "受取り" && quest.frequency == "weekly"))
            .toList();
        unfinishedQuests = quests
            .where((Quest quest) =>
                (quest.state == "未完了" && quest.frequency == "weekly"))
            .toList();
        finishedQuests = quests
            .where((Quest quest) =>
                (quest.state == "完了" && quest.frequency == "weekly"))
            .toList();
        displayedWeeklyQuests = [];
        displayedWeeklyQuests.addAll(acceptedQuests);
        displayedWeeklyQuests.addAll(unfinishedQuests);
        displayedWeeklyQuests.addAll(finishedQuests);
      }
    });
  }

// フィルターに応じて表示WeeklyQuestのソートを行う
  void sortAchievedQuests() {
    setState(() {
      List<Quest> finishedQuests;
      finishedQuests =
          quests.where((Quest quest) => (quest.state == "完了")).toList();
      displayedAchievedQuests = [];
      displayedAchievedQuests.addAll(finishedQuests);
    });
  }

  // FireStoreから、USERの持つQuestデータをとってくる
  Future<void> getQuests() async {
    db.userQuestsCollection(widget.uid).all().then((value) async {
      debugPrint('value: $value');
      List<Quest> questsData =
          value.map((e) => Quest.fromMap(e)).toList().cast<Quest>();
      for (var quest in questsData) {
        if (await checkCondition(quest)) {
          quest.state = "受取り";
        }
      }
      setState(() {
        quests = questsData;
        // checkConditionを使って、条件を満たしている場合はstateを受取りにする
        sortDailyQuests();
        sortWeeklyQuests();
        sortAchievedQuests();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint('uid: ${widget.uid}');
    getQuests();
    getLevel().then((value) {
      setState(() {
        level = value;
      });
    });
    Future(() async {
      Timer.periodic(const Duration(hours: 24), (Timer t) async {
        yesterdayData();
      });
    });
  }

  Future<int> getLevel() => db
      .usersCollection()
      .findById(widget.uid)
      .then((value) => value['level'] as int);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(),
            body: Center(
                child: Column(children: [
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "レベル: $level",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                  Text(
                    "EXP: $currentExp / $totalExp",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                ],
              ),
              ExpBar(
                width: 280,
                height: 20,
                color: Colors.green,
                expValue: (currentExp / totalExp),
              ),
              const SizedBox(height: 32),
              const TabBar(unselectedLabelColor: Colors.grey, tabs: <Widget>[
                Tab(icon: Icon(Icons.today, size: 29), child: Text("Daily")),
                Tab(
                    icon: Icon(Icons.view_week, size: 29),
                    child: Text("Weekly")),
                Tab(
                    icon: Icon(Icons.emoji_events, size: 29),
                    child: Text("Challenge")),
              ]),
              Expanded(
                child: TabBarView(
                  children: [
                    /// Daily画面
                    SingleChildScrollView(
                        child: Column(
                      children: [
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilterButton(
                              text: "全て",
                              color: AppColors.indigo,
                              state: filterState == "None",
                              onPressed: () {
                                setState(() {
                                  if (filterState != "None") {
                                    filterState = "None";
                                  }
                                  sortDailyQuests();
                                });
                              },
                            ),
                            FilterButton(
                              text: "未完了",
                              color: Colors.red.shade300,
                              state: filterState == "未完了",
                              onPressed: () {
                                setState(() {
                                  if (filterState != "未完了") {
                                    filterState = "未完了";
                                  } else {
                                    filterState = "None";
                                  }
                                  sortDailyQuests();
                                });
                              },
                            ),
                            FilterButton(
                              text: "受取り",
                              color: Colors.yellow.shade800,
                              state: filterState == "受取り",
                              onPressed: () {
                                setState(() {
                                  if (filterState != "受取り") {
                                    filterState = "受取り";
                                  } else {
                                    filterState = "None";
                                  }
                                  sortDailyQuests();
                                });
                              },
                            ),
                            FilterButton(
                              text: "完了",
                              color: Colors.green.shade400,
                              state: filterState == "完了",
                              onPressed: () {
                                setState(() {
                                  if (filterState != "完了") {
                                    filterState = "完了";
                                  } else {
                                    filterState = "None";
                                  }
                                  sortDailyQuests();
                                });
                              },
                            ),
                          ],
                        )),
                        for (int i = 0; i < displayedDailyQuests.length; i++)
                          QuestContent(
                            quest: displayedDailyQuests[i],
                            uid: widget.uid,
                            onChanged: () {
                              setState(() {
                                getQuests();
                              });
                            },
                          ),
                      ],
                    )),

                    /// Weekly画面
                    SingleChildScrollView(
                        child: Column(
                      children: [
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilterButton(
                              text: "全て",
                              color: AppColors.indigo,
                              state: filterState == "None",
                              onPressed: () {
                                setState(() {
                                  if (filterState != "None") {
                                    filterState = "None";
                                  }
                                  sortWeeklyQuests();
                                });
                              },
                            ),
                            FilterButton(
                              text: "未完了",
                              color: Colors.red.shade300,
                              state: filterState == "未完了",
                              onPressed: () {
                                setState(() {
                                  if (filterState != "未完了") {
                                    filterState = "未完了";
                                  } else {
                                    filterState = "None";
                                  }
                                  sortWeeklyQuests();
                                });
                              },
                            ),
                            FilterButton(
                              text: "受取り",
                              color: Colors.yellow.shade800,
                              state: filterState == "受取り",
                              onPressed: () {
                                setState(() {
                                  if (filterState != "受取り") {
                                    filterState = "受取り";
                                  } else {
                                    filterState = "None";
                                  }
                                  sortWeeklyQuests();
                                });
                              },
                            ),
                            FilterButton(
                              text: "完了",
                              color: Colors.green.shade400,
                              state: filterState == "完了",
                              onPressed: () {
                                setState(() {
                                  if (filterState != "完了") {
                                    filterState = "完了";
                                  } else {
                                    filterState = "None";
                                  }
                                  sortWeeklyQuests();
                                });
                              },
                            ),
                          ],
                        )),
                        for (int i = 0; i < displayedWeeklyQuests.length; i++)
                          QuestContent(
                            quest: displayedWeeklyQuests[i],
                            uid: widget.uid,
                            onChanged: () {
                              setState(() {
                                getQuests();
                              });
                            },
                          ),
                      ],
                    )),

                    /// 実績画面
                    SingleChildScrollView(
                        child: Column(
                      children: [
                        const SizedBox(height: 16),
                        for (int i = 0; i < displayedAchievedQuests.length; i++)
                          QuestContent(
                            quest: displayedAchievedQuests[i],
                            uid: widget.uid,
                            onChanged: () {
                              setState(() {
                                getQuests();
                              });
                            },
                          ),
                      ],
                    )),
                  ],
                ),
              )
            ]))));
  }
}
