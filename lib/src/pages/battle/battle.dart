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

  final dynamic image;

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
    this.offensive = 1,
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
        name: "bug",
        fullHP: 30,
        image: const Icon(Icons.bug_report, size: 120)),
    BattleCharacter(
        name: "rabbit",
        fullHP: 40,
        image: const Icon(Icons.cruelty_free, size: 120)),
  ];
  List<BattleCharacter> party = [
    BattleCharacter(name: "player", fullHP: 30),
  ];

  String turn = "party";
  String battleMessage = "コマンド？";

  bool showShade = true;

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
                    image: enemies[i].image,
                  ),
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
                    playerCrtHp: player.crtHP,
                    playerFullHp: player.fullHP,
                    onAttack: () {
                      setState(() {
                        turn = "enemy";
                        battleMessage = "${player.name}の攻撃！";
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          invader.crtHP -= player.offensive;
                          battleMessage =
                              "${invader.name}に${player.offensive}のダメージ";
                        });
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            battleMessage = "${invader.name}の攻撃！";
                          });
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              player.crtHP -= invader.offensive;
                              battleMessage =
                                  "${player.name}に${invader.offensive}のダメージ";
                              Future.delayed(const Duration(seconds: 2), () {
                                setState(() {
                                  battleMessage = "コマンド？";
                                  turn = "party";
                                });
                              });
                            });
                          });
                        });
                      });
                    },
                    onItem: () {},
                    onShield: () {},
                    onEscape: () {}),
                Visibility(
                    visible: turn != "party",
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
