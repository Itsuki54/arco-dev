import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// components
import '../../components/common/user_status.dart';
import '../../components/button/filter_button.dart';
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
  List<Quest> quests = [
    Quest(
        name: "影の通り魔",
        description: "都市の裏通りで謎の暗殺者が現れ、街を恐怖に陥れている。彼の正体を突き止め、街の安全を確保する。	",
        state: "完了",
        point: 120,
        id: 2),
    Quest(
        name: "失われた人工物",
        description: "現代都市で失われた魔法のアーティファクトを見つける。アーティファクトは古代の秘密を秘めている。	",
        state: "未完了",
        point: 100,
        id: 1),
    Quest(
        name: "魔法の暴走",
        description: "都市の中心で突如として発生した魔法の暴走を止めるため、その原因を調査して封じ込める。	",
        state: "受取り",
        point: 100,
        id: 1),
    Quest(
        name: "迷子の精霊",
        description: "都市の公園で迷子の精霊が現れ、助けを求めている。彼女を安全な場所へ導くことが求められる。	",
        state: "受取り",
        point: 100,
        id: 1),
    Quest(
        name: "闇のコンクラーヴ",
        description: "都市の地下に潜む闇の組織が暗躍している。その勢力を探り、彼らの野望を阻止するために立ち向かう。",
        state: "未完了",
        point: 100,
        id: 1),
  ];

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
