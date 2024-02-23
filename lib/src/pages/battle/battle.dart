import 'dart:math';

import 'package:arco_dev/src/utils/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../components/battle/battle_controller.dart';
import '../../components/common/exp_bar.dart';

class Enemy extends StatelessWidget {
  const Enemy({
    super.key,
    required this.enemyName,
    required this.enemyFullHp,
    required this.enemyCrtHp,
    required this.image,
  });

  final String enemyName;
  final int enemyFullHp;
  final int enemyCrtHp;

  final dynamic image;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(2),
        child: Column(children: [
          Align(
              alignment: Alignment.center,
              child: Column(children: [
                Text(enemyName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Text("HP: $enemyCrtHp",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                ExpBar(
                    width: 80,
                    height: 5,
                    expValue: enemyCrtHp / enemyFullHp,
                    color: Colors.green),
              ])),
        ]));
  }
}

class BattlePage extends StatefulWidget {
  const BattlePage({super.key, required this.uid, required this.enemies});

  final String uid;
  final List<Map<String, dynamic>> enemies;

  @override
  State<BattlePage> createState() => _BattlePage();
}

class _BattlePage extends State<BattlePage> {
  _BattlePage();

  List<Map<String, dynamic>> members = [];
  List<Map<String, dynamic>> enemies = [];
  Database db = Database();

  String turn = "party";
  int currentTurn = 0;
  String battleMessage = "コマンドを入力";

  bool showShade = true;

  List<Map> battleLog = [];
  List<Map> commandList = [];

  @override
  void initState() {
    super.initState();
    db.userPartyCollection(widget.uid).all().then((value) {
      setState(() {
        members = value.map((e) => {...e, "crtHp": e["status"]["hp"]}).toList();
        enemies = widget.enemies
            .map((e) => {...e, "crtHp": e["status"]["hp"]})
            .toList();
      });
    });
  }

  Future<void> updateDialogMessage(String message) async {
    // ダイアログを表示
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("バトル結果"),
          content: Text(message),
        );
      },
    );
  }

  Future<void> updateBattleState() async {
    String newDialogMessage = "";
    if (enemies.isNotEmpty) {
      for (final enemy in enemies) {
        if (enemy["crtHp"] <= 0) {
          newDialogMessage = "${enemy["name"]}を倒した！";
          await updateDialogMessage(newDialogMessage);
        }
      }
      setState(() {
        enemies.removeWhere((enemy) => enemy["crtHp"] <= 0);
      });
    }
    if (enemies.isEmpty) {
      final user = await db.usersCollection().findById(widget.uid);
      num exp = 0;
      for (int i = 0; i < enemies.length; i++) {
        exp += (enemies[i]['level'] + enemies[i]['rarity'] * 2) * 10;
      }
      await db.usersCollection().update(widget.uid, {
        "exp": FieldValue.increment(exp),
      });
      if (user['exp'] + exp >= user['level'] * 50) {
        await db
            .usersCollection()
            .update(widget.uid, {'level': FieldValue.increment(1)});
      }
      for (int i = 0; i < members.length; i++) {
        Map<String, dynamic> character = members[i];
        character['exp'] += exp;
        if (character['exp'] >=
            (character['level'] + character['rarity'] * 2) * 15) {
          character['level']++;
          character['exp'] = 0;
        }
        await db
            .userMembersCollection(widget.uid)
            .update(character['id'], character);
      }
      Navigator.pop(context, true);
    }

    if (members.isNotEmpty) {
      for (final character in members) {
        if (character["crtHp"] <= 0) {
          newDialogMessage = "${character["name"]}は倒れた！";
          await updateDialogMessage(newDialogMessage);
        }
      }
      setState(() {
        members.removeWhere((character) => character["crtHp"] <= 0);
      });
    }
    if (members.isEmpty) {
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return members.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
            ),
            body: Container(
              decoration: const BoxDecoration(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 360,
                        height: 380,
                        child: Wrap(
                          direction: Axis.vertical,
                          runAlignment: WrapAlignment.center,
                          spacing: 2.0,
                          runSpacing: 2.0,
                          children: [
                            for (int i = 0; i < enemies.length; i++)
                              Enemy(
                                enemyName: enemies[i]["name"],
                                enemyFullHp: enemies[i]["status"]["hp"],
                                enemyCrtHp: enemies[i]["crtHp"],
                                image: enemies[i]["image"],
                              ),
                          ],
                        )),
                    const Expanded(child: SizedBox()),
                    Text(
                      battleMessage,
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const Expanded(child: SizedBox()),
                    Column(
                      children: [
                        BattleController(
                            playerCrtHp: members[currentTurn]["crtHp"],
                            playerFullHp: members[currentTurn]["status"]["hp"],
                            playerName: members[currentTurn]["name"],
                            onAttack: () async {
                              if (currentTurn == members.length - 1) {
                                commandList.add({
                                  "player": members[currentTurn],
                                  "command": "attack"
                                });
                                setState(() {
                                  turn = "enemy";
                                });
                                debugPrint(commandList.length.toString());
                                for (int i = 0; i < commandList.length; i++) {
                                  if (enemies.isNotEmpty) {
                                    if (commandList[i]["command"] == "attack") {
                                      Map<String, dynamic> player =
                                          commandList[i]["player"];
                                      debugPrint("${player["name"]} attack");
                                      await Future.delayed(
                                          const Duration(seconds: 2), () {});
                                      setState(() {
                                        int attack = (player["status"]["atk"] *
                                                player["status"]["spd"]) -
                                            (enemies[0]["status"]["def"] *
                                                enemies[0]["status"]["spd"]);
                                        int newHp = attack.isNegative
                                            ? Random().nextInt(10)
                                            : attack;
                                        enemies[0]["crtHp"] =
                                            enemies[0]["crtHp"] - newHp < 0
                                                ? 0
                                                : enemies[0]["crtHp"] - newHp;
                                        battleMessage =
                                            "${enemies[0]["name"]}に${player["status"]["atk"]}のダメージ";
                                      });
                                      await updateBattleState();
                                      battleLog.add(commandList[i]);
                                    }
                                  }
                                }
                                if (enemies.isNotEmpty) {
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    setState(() {
                                      battleMessage =
                                          "${enemies[0]["name"]}の攻撃！";
                                    });
                                    Future.delayed(const Duration(seconds: 2),
                                        () async {
                                      battleLog.add({
                                        "player": enemies[0],
                                        "command": "attack"
                                      });
                                      setState(() {
                                        int attack = (enemies[0]["status"]
                                                    ["atk"] *
                                                enemies[0]["status"]["spd"]) -
                                            (members[0]["status"]["def"] *
                                                members[0]["status"]["spd"]);
                                        int newHp = attack.isNegative
                                            ? Random().nextInt(10)
                                            : attack;
                                        members[currentTurn]["crtHp"] =
                                            members[currentTurn]["crtHp"] -
                                                        newHp <
                                                    0
                                                ? 0
                                                : members[currentTurn]
                                                        ["crtHp"] -
                                                    newHp;
                                        battleMessage =
                                            "${members[currentTurn]["name"]}に${enemies[0]["status"]["atk"]}のダメージ";
                                      });
                                      await updateBattleState();
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        setState(() {
                                          battleMessage = "コマンドを入力";
                                          turn = "party";
                                          currentTurn = 0;
                                          commandList = [];
                                        });
                                      });
                                    });
                                  });
                                }
                              } else {
                                commandList.add({
                                  "player": members[currentTurn],
                                  "command": "attack"
                                });
                                setState(() {
                                  turn = "party";
                                  currentTurn++;
                                });
                              }
                            },
                            onItem: () {},
                            onShield: () {},
                            onEscape: () {}),
                        Visibility(
                            visible: turn == "enemy",
                            child: Card(
                              elevation: 0,
                              color: Colors.black.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                              ),
                            ))
                      ],
                    ),
                  ]),
            ));
  }
}
