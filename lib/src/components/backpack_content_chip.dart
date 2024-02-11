import 'package:flutter/material.dart';

class BackpackContentChip extends StatelessWidget {
  BackpackContentChip({
    super.key,
    required this.name,
    required this.level,
    required this.icon,
    required this.color,
  });

  final String name;
  final int level;
  final dynamic icon;
  final Color color;

  TextStyle textStyle =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

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
            onPressed: () {},
            child: icon,
          )),
      Text(name, style: textStyle),
      Text("Lv: $level", style: textStyle)
    ]);
  }
}
