import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';

import '../../components/battle/battle_controller.dart';
// components
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
          image,
        ]));
  }
}

class BattleCharacter {
  BattleCharacter({
    required this.name,
    required this.fullHP,
    required this.job,
    required this.atk,
    required this.def,
    required this.spd,
    required this.description,
    required this.image,
  }) {
    crtHP = fullHP;
  }

  late int crtHP;
  final String name;
  final int fullHP;
  final String job;
  final int atk;
  final int def;
  final int spd;
  final String description;
  final dynamic image;
}

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  State<BattlePage> createState() => _BattlePage();
}

class _BattlePage extends State<BattlePage> {
  _BattlePage();

  // テスト
  List<BattleCharacter> enemies = [
    BattleCharacter(
        name: "Invader",
        fullHP: 2,
        job: "attacker",
        atk: 2,
        def: 2,
        spd: 2,
        description: "",
        image: const Icon(Icons.bug_report))
  ];
  List<BattleCharacter> party = [
    BattleCharacter(
        name: "勇者",
        fullHP: 2,
        job: "attacker",
        atk: 2,
        def: 2,
        spd: 2,
        description: "",
        image: const Icon(Icons.bug_report)),
    BattleCharacter(
        name: "魔法使い",
        fullHP: 2,
        job: "attacker",
        atk: 2,
        def: 2,
        spd: 2,
        description: "",
        image: const Icon(Icons.bug_report)),
  ];

  int currentTurn = 0; // パーティの何番目がコマンドを入力しているか
  String battleMessage = "コマンド？";

  bool visibility = false;

  List<Map> battleLog = []; // 戦闘ログ
  List<Map> commandList = []; // 一回分のプレイヤーパーティの行動をスタックする

  @override
  void initState() {
    super.initState();
  }

  void updateDialogMessage(String message) {
    // ダイアログを表示
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("バトル結果"),
          content: Text(message),
        );
      },
    );
  }

  void updateBattleState() {
    int enemyNum = enemies.length;
    int partyNum = party.length;

    String newDialogMessage = "";
    if (enemyNum == 0) {
      newDialogMessage = "敵を全滅させた！";
    } else {
      for (BattleCharacter enemy in enemies) {
        if (enemy.crtHP <= 0) {
          newDialogMessage = "${enemy.name}を倒した！";
          updateDialogMessage(newDialogMessage);
        }
      }
      enemies.removeWhere((enemy) => enemy.crtHP <= 0);
    }

    if (partyNum == 0) {
      newDialogMessage = "全滅した！";
    } else {
      for (BattleCharacter character in party) {
        if (character.crtHP <= 0) {
          newDialogMessage = "${character.name}は倒れた！";
          updateDialogMessage(newDialogMessage);
        }
      }
      party.removeWhere((character) => character.crtHP <= 0);
    }
  }

  // ターン一回分のコマンドを消費する
  void oneTurn() {
    // プレイヤーパーティの行動
    setState(() {
      visibility = true;
    });
    commandList.map((command) {
      setState(() {
        if (command["command"] == "atk") {
          battleMessage = "${command["character"].name}の攻撃！！";
        }
      });
      sleep(const Duration(seconds: 2));
    });
    commandList.clear();

    // 相手の行動を決める

    // 相手の行動

    setState(() {
      visibility = false;
      battleMessage = "コマンド？";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
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
                            enemyName: enemies[i].name,
                            enemyFullHp: enemies[i].fullHP,
                            enemyCrtHp: enemies[i].crtHP,
                            image: enemies[i].image,
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
                Stack(
                  children: [
                    BattleController(
                        playerCrtHp: party[currentTurn].crtHP,
                        playerFullHp: party[currentTurn].fullHP,
                        playerName: party[currentTurn].name,
                        onAttack: () {
                          // プレイヤーパーティ全員入力し終わったら
                          commandList.add({
                            "character": party[currentTurn],
                            "command": "atk"
                          });
                          if (currentTurn == party.length - 1) {
                            currentTurn = 0;
                            // コマンド入力終了
                            // ターンを発火する
                            oneTurn();
                          } else {
                            setState(() {
                              currentTurn++;
                            });
                          }

                          //if (currentTurn == party.length - 1) {
                          //  commandList.add({
                          //    "player": party[currentTurn],
                          //    "command": "attack"
                          //  });
                          //  setState(() {
                          //    turn = "enemy";
                          //  });
                          //  debugPrint(commandList.length.toString());
                          //  for (int i = 0; i < commandList.length; i++) {
                          //    if (commandList[i]["command"] == "attack") {
                          //      BattleCharacter player =
                          //          commandList[i]["player"];
                          //      debugPrint("${player.name} attack");
                          //      await Future.delayed(
                          //          const Duration(seconds: 2), () {});
                          //      setState(() {
                          //        enemies[0].crtHP -= player.atk;
                          //        battleMessage =
                          //            "${enemies[0].name}に${player.atk}のダメージ";
                          //        updateBattleState();
                          //      });
                          //      battleLog.add(commandList[i]);
                          //    }
                          //  }
                          //  Future.delayed(const Duration(seconds: 2), () {
                          //    setState(() {
                          //      battleMessage = "${enemies[0].name}の攻撃！";
                          //    });
                          //    Future.delayed(const Duration(seconds: 2), () {
                          //      battleLog.add({
                          //        "player": enemies[0],
                          //        "command": "attack"
                          //      });
                          //      setState(() {
                          //        party[currentTurn].crtHP -= enemies[0].atk;

                          //        battleMessage =
                          //            "${party[currentTurn].name}に${enemies[0].atk}のダメージ";
                          //        updateBattleState();
                          //        Future.delayed(const Duration(seconds: 2),
                          //            () {
                          //          setState(() {
                          //            battleMessage = "コマンド？";
                          //            turn = "party";
                          //            currentTurn = 0;
                          //            commandList = [];
                          //          });
                          //        });
                          //      });
                          //    });
                          //  });
                          //} else {
                          //  commandList.add({
                          //    "player": party[currentTurn],
                          //    "command": "attack"
                          //  });
                          //  setState(() {
                          //    turn = "party";
                          //    currentTurn++;
                          //  });
                          //}
                        },
                        onItem: () {},
                        onShield: () {},
                        onEscape: () {}),
                    Visibility(
                        visible: visibility,
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
                const SizedBox(height: 30)
              ]),
        ));
  }
}
