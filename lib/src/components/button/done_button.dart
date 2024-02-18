import 'package:flutter/material.dart';

class DoneButton extends StatefulWidget {
  const DoneButton({super.key, this.state = "未完了"});

  /* ボタンの状態
    - "未完了"
    - "受取る"
    - "完了"
  */
  final String state;

  @override
  State<DoneButton> createState() => _DoneButton();
}

class _DoneButton extends State<DoneButton> {
  late String state = widget.state;
  late String buttonText = widget.state;
  late Color buttonColor = colorFromState(widget.state);
  late bool canTap = (widget.state == "受取る");

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

      // テスト用 ----
      case "完了":
        return "未完了";
      //----

      default:
        return state;
    }
  }

  void onTap() {
    setState(() {
      state = transState(state); // 状態を遷移
      buttonText = state;
      buttonColor = colorFromState(state);
      canTap = (state == "受取る");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap, // テスト用
      //onPressed: null,
      style: ElevatedButton.styleFrom(
          elevation: 3,
          backgroundColor: buttonColor,
          disabledBackgroundColor: buttonColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: SizedBox(
          width: 52,
          height: 30,
          child: Center(
              child: Text(buttonText,
                  style: const TextStyle(
                      //color: canTap ? Colors.white : Colors.grey.shade300,
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)))),
    );
  }
}
