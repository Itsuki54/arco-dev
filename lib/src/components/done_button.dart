import 'package:flutter/material.dart';

class DoneButton extends StatefulWidget {
  const DoneButton({super.key, this.done = false});

  final bool done;

  @override
  State<DoneButton> createState() => _DoneButton();
}

class _DoneButton extends State<DoneButton> {
  late bool done = widget.done;
  late String buttonText = widget.done ? "完了" : "未完了";
  late Color buttonColor =
      widget.done ? Colors.green.shade400 : Colors.red.shade300;

  void onTap() {
    setState(() {
      done = !done;
      buttonText = done ? "完了" : "未完了";
      buttonColor = done ? Colors.green.shade400 : Colors.red.shade300;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
          elevation: 1,
          backgroundColor: buttonColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: SizedBox(
          width: 48,
          height: 30,
          child: Center(
              child: Text(buttonText,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)))),
    );
  }
}
