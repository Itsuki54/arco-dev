import 'package:flutter/material.dart';

class QuestStateChip extends StatefulWidget {
  const QuestStateChip({super.key, this.state = "未完了"});

  /* ボタンの状態
    - "未完了"
    - "受取る"
    - "完了"
  */
  final String state;

  @override
  State<QuestStateChip> createState() => _QuestStateChip();
}

class _QuestStateChip extends State<QuestStateChip> {
  late String state = widget.state;
  late String buttonText = widget.state;
  late Color buttonColor = colorFromState(widget.state);

  // 各状態の色を指定
  Color colorFromState(String state) {
    switch (state) {
      case "未完了":
        return Colors.red.shade300;
      case "受取る":
        return Colors.yellow.shade800;
      case "完了":
        return Colors.green.shade400;
      default:
        return Colors.white;
    }
  }

  // 状態を遷移させる
  String transState(String state) {
    switch (state) {
      case "未完了":
        return "受取る";
      case "受取る":
        return "完了";
      case "完了":
        return "未完了";
      default:
        return state;
    }
  }

  void onChange({String inputState = 'null'}) {
    setState(() {
      if (inputState != 'null') {
        state = transState(inputState);
      } else {
        state = transState(state);
      }
      buttonText = state;
      buttonColor = colorFromState(state);
    });
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
              child: Text(buttonText,
                  style: const TextStyle(
                      //color: canTap ? Colors.white : Colors.grey.shade300,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)))),
    );
  }
}
