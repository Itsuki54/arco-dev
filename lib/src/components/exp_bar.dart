import 'package:flutter/material.dart';

class ExpBar extends StatefulWidget {
  ExpBar({
    super.key,
    required this.expValue,
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;
  double expValue;

  @override
  State<ExpBar> createState() => _ExpBar();
}

class _ExpBar extends State<ExpBar> {
  // 値の更新
  void update_value(double value) {
    setState(() {
      widget.expValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            minHeight: 30,
            value: widget.expValue,
          ),
        ));
  }
}
