import 'package:flutter/material.dart';

/*
　本Widgetは、受け取ったStateに応じてその見た目を変えるものです
　colorFromStateメソッドにstateを渡すことで、色が変わります
  表示される文字は、stateの文字列そのままです
*/
class QuestStateChip extends StatelessWidget {
  QuestStateChip({super.key, this.state = "未完了"});

  /* ボタンの状態
    - "未完了"
    - "受取る"
    - "完了"
  */
  final String state;
  late Color buttonColor = colorFromState(state);

  // 各状態の色を指定
  Color colorFromState(String state) {
    switch (state) {
      case "受取り":
        return Colors.yellow.shade800;
      case "完了":
        return Colors.green.shade400;
      default:
        return Colors.red.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: buttonColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
          width: 78,
          height: 40,
          child: Center(
              child: Text(state,
                  style: const TextStyle(
                      //color: canTap ? Colors.white : Colors.grey.shade300,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)))),
    );
  }
}
