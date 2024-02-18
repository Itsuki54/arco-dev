import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// components
import '../common/exp_bar.dart';
import '../button/middle_battle_cmd_button.dart';

class BattleController extends StatelessWidget {
  const BattleController(
      {super.key,
      required this.onAttack,
      required this.onShield,
      required this.onItem,
      required this.onEscape,
      this.playerName = "PlayerName",
      this.playerFullHp = 32,
      this.playerCrtHp = 15});

  final String playerName;
  final int playerFullHp;
  final int playerCrtHp;

  final dynamic onAttack;
  final dynamic onShield;
  final dynamic onItem;
  final dynamic onEscape;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
        height: 260,
        child: Stack(
          children: [
            Align(
                alignment: const Alignment(-1.0, -0.7),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(children: [
                    Text(playerName,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("HP: $playerCrtHp",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ExpBar(
                        width: 90,
                        height: 8,
                        expValue: playerCrtHp / playerFullHp,
                        color: Colors.green),
                  ]),
                )),
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
            // 赤いボタンだけ、直に書いている
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
                            elevation: 5),
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
