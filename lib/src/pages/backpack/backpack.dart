import 'package:arco_dev/src/components/battle/battle_log.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// components
import '../../components/button/simple_route_button.dart';
import '../../components/common/ripples.dart';
// pages
import './party.dart';

class BackpackPage extends StatelessWidget {
  BackpackPage({Key? key, required this.uid, this.battleResults})
      : super(key: key);

  final String uid;
  final Map<String, dynamic>? battleResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 30),
      body: Center(
        child: battleResults != null && battleResults!.isNotEmpty
            ? ListView.builder(
                itemCount: battleResults!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return BattleLog(
                                expLog: battleResults![index]["exp"],
                                log: battleResults![index]["result"],
                                win: battleResults![index]["win"],
                                party: battleResults![index]["party"]);
                          });
                    },
                    title: Text(battleResults!.keys.elementAt(index)),
                    subtitle:
                        Text(battleResults!.values.elementAt(index).toString()),
                  );
                })
            : Column(children: [
                const SizedBox(height: 40),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                              alignment: Alignment(0, 0),
                              child: SizedBox(
                                  height: 250,
                                  width: 250,
                                  child: WaterRipple())),
                          Align(
                              alignment: Alignment(0, 0),
                              child: Icon(
                                Icons.smartphone,
                                size: 120,
                              )),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "探索中...",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SimpleRouteButton(
                  title: "編成",
                  icon: const Icon(Icons.assignment_ind, size: 45),
                  nextPage: PartyPage(uid: uid),
                ),
                const SizedBox(height: 40),
              ]),
      ),
    );
  }
}
