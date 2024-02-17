import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "package:flutter_svg/flutter_svg.dart";
import 'package:audioplayers/audioplayers.dart';
// components
import '../../components/exp_bar.dart';
import '../../components/battle_controller.dart';
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

  final SvgPicture image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 180,
        height: 190,
        child: Column(children: [
          Align(
              alignment: Alignment.center,
              child: Column(children: [
                Text(enemyName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                Text("HP: $enemyCrtHp",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                ExpBar(
                    width: 80,
                    height: 10,
                    expValue: enemyCrtHp / enemyFullHp,
                    color: Colors.green),
              ])),
          image,
          //svgpicture.asset("assets/images/invader.svg",
          //    width: 120,
          //    colorfilter:
          //        const colorfilter.mode(colors.black87, blendmode.srcin)),
        ]));
  }
}

class BattleCharacter {
  BattleCharacter({
    required this.name,
    required this.fullHP,
    this.attribute = "nemo",
    this.power = 1,
    this.defense = 1,
    this.offensive = 1,
    this.helth = 1,
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
}

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  State<BattlePage> createState() => _BattlePage();
}

class _BattlePage extends State<BattlePage> {
  _BattlePage();

  bool canControl = true;

  String enemyName = "Invader";
  final int enemyFullHp = 20;
  final int playerFullHp = 100;

  late int enemyCrtHp = enemyFullHp;
  late int playerCrtHp = playerFullHp ~/ 2;

  List<BattleCharacter> enemies = [
    BattleCharacter(name: "Invader", fullHP: 30),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          decoration: const BoxDecoration(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 80),
            Wrap(
              children: [
                for (int i = 0; i < enemies.length; i++)
                  Enemy(
                      enemyName: enemies[i].name,
                      enemyFullHp: enemies[i].fullHP,
                      enemyCrtHp: enemies[i].crtHP,
                      image: SvgPicture.asset("assets/images/invader.svg",
                          width: 120,
                          colorFilter: const ColorFilter.mode(
                              Colors.black87, BlendMode.srcIn))),
              ],
            ),
            const Expanded(child: SizedBox()),
            Text(
              battleMessage,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                            BattleCharacter player = commandList[i]["player"];
                            debugPrint("${player.name} attack");
                            await Future.delayed(
                                const Duration(seconds: 2), () {});
                            setState(() {
                              enemies[0].crtHP -= player.offensive;
                              battleMessage =
                                  "${enemies[0].name}に${player.offensive}のダメージ";
                            });
                            battleLog.add(commandList[i]);
                          }
                        }
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            battleMessage = "${enemies[0].name}の攻撃！";
                          });
                          Future.delayed(const Duration(seconds: 2), () {
                            battleLog.add(
                                {"player": enemies[0], "command": "attack"});
                            setState(() {
                              party[currentTurn].crtHP -= enemies[0].offensive;
                              battleMessage =
                                  "${party[currentTurn].name}に${enemies[0].offensive}のダメージ";
                              Future.delayed(const Duration(seconds: 2), () {
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
