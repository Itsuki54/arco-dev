import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// components
//import '../../components/done_button.dart';
import '../../components/user_status.dart';
import '../../components/quest_state_chip.dart';
import '../../components/quest_dialog.dart';
// structs
import '../../structs/quest.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});
  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  List<Quest> quests = [
    Quest(
        name: "失われた人工物",
        description: "現代都市で失われた魔法のアーティファクトを見つける。アーティファクトは古代の秘密を秘めている。	",
        state: "未完了",
        point: 100,
        id: 1),
    Quest(
        name: "影の通り魔",
        description: "都市の裏通りで謎の暗殺者が現れ、街を恐怖に陥れている。彼の正体を突き止め、街の安全を確保する。	",
        state: "完了",
        point: 120,
        id: 2),
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 250,
            flexibleSpace: const Column(
              children: [
                SizedBox(height: 64),
                UserStatus(),
              ],
            ),
            bottom:
                const TabBar(unselectedLabelColor: Colors.grey, tabs: <Widget>[
              Tab(icon: Icon(Icons.today), child: Text("Daily")),
              Tab(icon: Icon(Icons.view_week), child: Text("Weekly")),
              Tab(icon: Icon(Icons.calendar_month), child: Text("Monthly")),
            ]),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                  child: Column(
                children: [
                  const SizedBox(height: 16),
                  for (int i = 0; i < quests.length; i++)
                    Container(
                      width: 320,
                      height: 70,
                      margin: const EdgeInsets.all(6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  QuestDialog(quest: quests[i]));
                        },
                        child: Container(
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(quests[i].name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      "${quests[i].point} point",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                const Expanded(child: SizedBox()),
                                //DoneButton(),
                                QuestStateChip(state: quests[i].state),
                              ],
                            )),
                      ),
                    )
                ],
              ))
            ],
          ),
        ));
  }
}
