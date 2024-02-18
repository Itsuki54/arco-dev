import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "package:flutter_svg/flutter_svg.dart";
import 'package:audioplayers/audioplayers.dart';
// components
import '../../components/common/exp_bar.dart';
import '../../components/battle/battle_controller.dart';
// structs
import '../../structs/battle_package.dart';

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

//SvgPicture.asset("assets/images/invader.svg",
//        width: 120,
//        colorFilter: ColorFilter.mode(Colors.black87, BlendMode.srcIn))

class BattleCharacter {
  BattleCharacter({
    required this.name,
    required this.fullHP,
    this.attribute = "nemo",
    this.power = 1,
    this.defense = 1,
    this.offensive = 15,
    this.helth = 1,
    this.image = const Icon(Icons.bug_report, size: 120),
  }) {
    crtHP = fullHP;
  }

  final String name;
  final int fullHP;
  late int crtHP;
  final String attribute;
  final int power;
  final int defense;
  final int offensive;
  final double helth;
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
  BattleCharacter invader = BattleCharacter(name: "Invader", fullHP: 30);
  BattleCharacter player = BattleCharacter(name: "player", fullHP: 30);

  List<BattleCharacter> enemies = [
    BattleCharacter(
        name: "bug", fullHP: 30, image: const Icon(Icons.bug_report, size: 80)),
    BattleCharacter(
        name: "rabbit",
        fullHP: 30,
        image: const Icon(Icons.cruelty_free, size: 80)),
    BattleCharacter(
        name: "rabbit",
        fullHP: 30,
        image: const Icon(Icons.cruelty_free, size: 80)),
  ];
  List<BattleCharacter> party = [
    BattleCharacter(name: "player", fullHP: 30),
    BattleCharacter(name: "player2", fullHP: 30),
  ];

  String turn = "party";
  int currentTurn = 0;
  String battleMessage = "コマンド？";

  bool showShade = true;

  List<Map> battleLog = [];
  List<Map> commandList = [];

  @override
  void initState() {
    super.initState();
  }

  void updateDialogMessage(String message) {
    String dialogMessage = "";
    setState(() {
      dialogMessage = message;
    });

    // ダイアログを表示
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("バトル結果"),
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
        }ø
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
                        onAttack: () async {
                          if (currentTurn == party.length - 1) {
                            commandList.add({
                              "player": party[currentTurn],
                              "command": "attack"
                            });
                            setState(() {
                              turn = "enemy";
                            });
                            debugPrint(commandList.length.toString());
                            for (int i = 0; i < commandList.length; i++) {
                              if (commandList[i]["command"] == "attack") {
                                BattleCharacter player =
                                    commandList[i]["player"];
                                debugPrint("${player.name} attack");
                                await Future.delayed(
                                    const Duration(seconds: 2), () {});
                                setState(() {
                                  enemies[0].crtHP -= player.offensive;
                                  battleMessage =
                                      "${enemies[0].name}に${player.offensive}のダメージ";
                                  updateBattleState();
                                });
                                battleLog.add(commandList[i]);
                              }
                            }
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                battleMessage = "${enemies[0].name}の攻撃！";
                              });
                              Future.delayed(const Duration(seconds: 2), () {
                                battleLog.add({
                                  "player": enemies[0],
                                  "command": "attack"
                                });
                                setState(() {
                                  party[currentTurn].crtHP -=
                                      enemies[0].offensive;
                                  battleMessage =
                                      "${party[currentTurn].name}に${enemies[0].offensive}のダメージ";
                                  updateBattleState();
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    setState(() {
                                      battleMessage = "コマンド？";
                                      turn = "party";
                                      currentTurn = 0;
                                      commandList = [];
                                    });
                                  });
                                });
                              });
                            });
                          } else {
                            commandList.add({
                              "player": party[currentTurn],
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
                const SizedBox(height: 30)
              ]),
        ));
  }
}
