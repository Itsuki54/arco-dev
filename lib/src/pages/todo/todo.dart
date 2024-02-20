import 'package:flutter/material.dart';

import '../../components/button/filter_button.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// components
import '../../components/common/user_status.dart';
import '../../components/quest/quest_content.dart';
// structs
import '../../structs/quest.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});
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

  // FilterButtonの状態
  bool unfinished = false;
  bool receiption = false;

  // 仮で置いているQuestデータ
  List<Quest> quests = [];

  // 表示用
  late List<Quest> displayedQuests = quests;

  // 表示Questの状態変更
  void transFilterState(String nextState) {
    filterState = nextState;
    switch (filterState) {
      case "未完了":
        unfinished = true;
        receiption = false;
        break;
      case "受取り":
        unfinished = false;
        receiption = true;
      default:
        unfinished = false;
        receiption = false;
        break;
    }
  }

  // フィルターに応じて表示Questのソートを行う
  void sortQuests() {
    setState(() {
      if (filterState != "None") {
        displayedQuests = quests
            .where((Quest quest) => (quest.state == filterState))
            .toList();
      } else {
        displayedQuests = quests;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(),
            body: Column(children: [
              UserStatus(),
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
                    for (int i = 0; i < 3; i++)
                      SingleChildScrollView(
                          child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: const EdgeInsets.all(2),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: const BorderSide(width: 2.5)),
                                    onPressed: () {},
                                    child: const Icon(Icons.tune),
                                  )),
                              FilterButton(
                                text: "未完了",
                                color: Colors.red.shade300,
                                state: unfinished,
                                onPressed: () {
                                  setState(() {
                                    if (unfinished == false) {
                                      transFilterState("未完了");
                                    } else {
                                      transFilterState("None");
                                    }
                                    sortQuests();
                                  });
                                },
                              ),
                              FilterButton(
                                text: "受取り",
                                color: Colors.yellow.shade800,
                                state: receiption,
                                onPressed: () {
                                  setState(() {
                                    if (receiption == false) {
                                      transFilterState("受取り");
                                    } else {
                                      transFilterState("None");
                                    }
                                    sortQuests();
                                  });
                                },
                              ),
                            ],
                          ),
                          for (int i = 0; i < displayedQuests.length; i++)
                            QuestContent(quest: displayedQuests[i]),
                        ],
                      ))
                  ],
                ),
              )
            ])));
  }
}
