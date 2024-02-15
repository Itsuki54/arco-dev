import 'package:flutter/material.dart';
import "package:flutter_svg/flutter_svg.dart";
import 'package:audioplayers/audioplayers.dart';
// components
import '../../components/exp_bar.dart';
import '../../components/battle_controller.dart';

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  State<BattlePage> createState() => _BattlePage();
}

class _BattlePage extends State<BattlePage> {
  bool canControl = true;

  String enemyName = "Invader";
  final int enemyFullHp = 20;
  final int playerFullHp = 100;

  late int enemyCrtHp = enemyFullHp;
  late int playerCrtHp = playerFullHp ~/ 2;

  final audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          decoration: const BoxDecoration(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            //const Expanded(child: SizedBox()),
            const SizedBox(height: 80),
            SizedBox(
                width: 250,
                height: 350,
                child: Column(children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: Column(children: [
                        Text(enemyName,
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold)),
                        Text("HP: $enemyCrtHp",
                            style: const TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold)),
                        ExpBar(
                            width: 100,
                            height: 10,
                            expValue: enemyCrtHp / enemyFullHp,
                            color: Colors.green),
                      ])),
                  SvgPicture.asset("assets/images/invader.svg",
                      width: 250,
                      height: 250,
                      colorFilter: const ColorFilter.mode(
                          Colors.black87, BlendMode.srcIn)),
                ])),
            const Expanded(child: SizedBox()),
            BattleController(
                playerCrtHp: playerCrtHp,
                playerFullHp: playerFullHp,
                onAttack: () {
                  setState(() {
                    enemyCrtHp -= 2;
                    if (enemyCrtHp <= 0) {
                      Navigator.of(context).pop();
                    }
                    // 動かない!!
                    //audioPlayer
                    //    .play(AssetSource("assets/sounds/battle/attack.mp3"));
                  });
                },
                onItem: () {
                  setState(() {
                    playerCrtHp += 2;
                  });
                },
                onShield: () {},
                onEscape: () {}),
            const SizedBox(height: 30)
          ]),
        ));
  }
}
