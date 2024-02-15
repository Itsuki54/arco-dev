import 'package:flutter/material.dart';

class ExpBar extends StatelessWidget {
  const ExpBar({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    this.expValue = 0.1,
  });

  final double width;
  final double height;
  final Color color;
  final double expValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 30,
            value: expValue,
          ),
        ));
  }
}
