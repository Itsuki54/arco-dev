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

class Battle {
  List<BattleCharacter> party = [BattleCharacter(name: "Player", fullHP: 100)];
  List<BattleCharacter> enemies = [BattleCharacter(name: "Enemy", fullHP: 10)];
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

  // テスト
  BattleCharacter invader = BattleCharacter(name: "Invader", fullHP: 30);
  BattleCharacter player = BattleCharacter(name: "player", fullHP: 30);
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
                for (int i = 0; i < 2; i++)
                  Enemy(
                      enemyName: invader.name,
                      enemyFullHp: invader.fullHP,
                      enemyCrtHp: invader.crtHP,
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
