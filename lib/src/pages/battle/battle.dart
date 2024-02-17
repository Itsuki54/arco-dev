import 'package:flutter/material.dart';
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
    required this.fullHP,
    this.attribute = "nemo",
    this.power = 1,
    this.defense = 1,
    this.offensive = 1,
    this.helth = 1,
  }) {
    crtHP = fullHP;
  }

  late int crtHP;
  final int fullHP;
  final String attribute;
  final int power;
  final int defense;
  final int offensive;
  final double helth;
}

class Battle {}

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
                      enemyName: enemyName,
                      enemyFullHp: enemyFullHp,
                      enemyCrtHp: enemyCrtHp,
                      image: SvgPicture.asset("assets/images/invader.svg",
                          width: 120,
                          colorFilter: const ColorFilter.mode(
                              Colors.black87, BlendMode.srcIn))),
              ],
            ),
            const Expanded(child: SizedBox()),
            Stack(
              children: [
                BattleController(
                    playerCrtHp: playerCrtHp,
                    playerFullHp: playerFullHp,
                    onAttack: () {},
                    onItem: () {},
                    onShield: () {},
                    onEscape: () {}),
                Visibility(
                    visible: !showShade,
                    child: Card(
                      elevation: 0,
                      color: Colors.black.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 260,
                      ),
                    ))
              ],
            ),
            const SizedBox(height: 30)
          ]),
        ));
  }
}
