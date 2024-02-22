import 'package:arco_dev/src/utils/database.dart';
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
    db.userQuestsCollection(widget.uid).all().then((value) {
      debugPrint('value: $value');
      setState(() {
        quests = value.map((e) => Quest.fromMap(e)).toList().cast<Quest>();
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
  }

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                        ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                        ),
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
