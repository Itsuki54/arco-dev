import 'package:flutter/material.dart';

class BackpackContentChip extends StatelessWidget {
  const BackpackContentChip(
      {super.key,
      required this.name,
      this.level,
      required this.icon,
      required this.color,
      required this.onPressed});

  final String name;
  final int? level;
  final dynamic icon;
  final Color color;
  final VoidCallback onPressed;

  final TextStyle textStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          width: 100,
          height: 100,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                backgroundColor: color),
            onPressed: onPressed,
            child: icon,
          )),
      Text(name, style: textStyle),
      level != null ? Text("Lv: $level", style: textStyle) : const SizedBox()
    ]);
  }
}
