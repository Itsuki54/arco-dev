import 'package:flutter/material.dart';
import "package:flutter_svg/flutter_svg.dart";
// components
import '../../components/exp_bar.dart';

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  State<BattlePage> createState() => _BattlePage();
}

class MiddleBattleCmdButton extends StatelessWidget {
  const MiddleBattleCmdButton({
    super.key,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  final Color color;
  final dynamic icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              side: BorderSide(color: color, width: 8),
              elevation: 3,
              backgroundColor: Colors.white),
          child: icon),
    );
  }
}

class BattleController extends StatelessWidget {
  const BattleController(
      {super.key,
      required this.onAttack,
      required this.onShield,
      required this.onItem,
      required this.onEscape});

  final VoidCallback onAttack;
  final VoidCallback onShield;
  final VoidCallback onItem;
  final VoidCallback onEscape;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
        height: 260,
        child: Stack(
          children: [
            Align(
                alignment: const Alignment(-0.1, 1.0),
                child: Container(
                    margin: const EdgeInsets.all(5),
                    child: MiddleBattleCmdButton(
                      color: Colors.blue.shade700,
                      icon: Icon(
                        Icons.shield_outlined,
                        size: 50,
                        color: Colors.blue.shade700,
                      ),
                      onPressed: onShield,
                    ))),
            Align(
                alignment: const Alignment(0.1, -0.6),
                child: Container(
                    margin: const EdgeInsets.all(5),
                    child: MiddleBattleCmdButton(
                      color: Colors.green.shade700,
                      icon: Icon(
                        Icons.directions_run,
                        size: 50,
                        color: Colors.green.shade700,
                      ),
                      onPressed: onEscape,
                    ))),
            Align(
                alignment: const Alignment(1.0, -1.0),
                child: Container(
                    margin: const EdgeInsets.all(5),
                    child: MiddleBattleCmdButton(
                      color: Colors.yellow.shade800,
                      icon: Icon(
                        Icons.category,
                        size: 50,
                        color: Colors.yellow.shade800,
                      ),
                      onPressed: onItem,
                    ))),
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    margin: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: 140,
                      height: 140,
                      child: ElevatedButton(
                        onPressed: onAttack,
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                color: Colors.red.shade400, width: 8),
                            elevation: 2),
                        child: SvgPicture.asset("assets/images/sword.svg",
                            width: 80,
                            height: 80,
                            colorFilter: ColorFilter.mode(
                                Colors.red.shade400, BlendMode.srcIn)),
                      ),
                    ))),
          ],
        ));
  }
}

class _BattlePage extends State<BattlePage> {
  String enemyName = "Invader";
  final int enemyFullHp = 20;
  final int playerFullHp = 100;

  late int enemyCrtHp = enemyFullHp;
  late int playerCrtHp = playerFullHp;

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
                onAttack: () {
                  setState(() {
                    enemyCrtHp -= 2;
                    if (enemyCrtHp <= 0) {
                      Navigator.of(context).pop();
                    }
                  });
                },
                onShield: () {},
                onItem: () {},
                onEscape: () {}),
            const SizedBox(height: 30)
          ]),
        ));
  }
}
