import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// components
import '../../components/simple_route_button.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Scaffold(
        appBar: AppBar(toolbarHeight: 30),
        body: Center(
          child: Column(children: []),
=======
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
              for (int i = 0; i < 3; i++)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
>>>>>>> Stashed changes
        ));
  }
}
