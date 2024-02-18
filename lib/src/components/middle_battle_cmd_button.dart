import 'package:flutter/material.dart';

class MiddleBattleCmdButton extends StatelessWidget {
  const MiddleBattleCmdButton({
    super.key,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  final Color color;
  final dynamic icon;
  final dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              side: BorderSide(color: color, width: 8),
              elevation: 5,
              backgroundColor: Colors.white),
          child: icon),
    );
  }
}
