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

class _BattlePage extends State<BattlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        //const Expanded(child: SizedBox()),
        const SizedBox(height: 100),
        SizedBox(
            width: 250,
            height: 350,
            child: Column(children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: Column(children: [
                    Text("Invader",
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold)),
                    Text("HP: 638",
                        style: const TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold)),
                    const ExpBar(
                        width: 100,
                        height: 10,
                        expValue: 0.5,
                        color: Colors.green),
                  ])),
              SvgPicture.asset("assets/images/invader.svg",
                  width: 250,
                  height: 250,
                  colorFilter:
                      const ColorFilter.mode(Colors.black87, BlendMode.srcIn)),
            ])),
        const Expanded(child: SizedBox()),
        SizedBox(
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
                          onPressed: () {},
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
                          onPressed: () {},
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
                          onPressed: () {},
                        ))),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: ElevatedButton(
                            onPressed: () {},
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
            )),
        const SizedBox(height: 30)
      ]),
    ));
  }
}
