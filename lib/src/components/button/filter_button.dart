import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.state = false,
  });

  final bool state;
  final String text;
  final Color color;
  final VoidCallback onPressed;

  @override
  State<FilterButton> createState() => _FilterButton();
}

class _FilterButton extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(0.5),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: widget.state ? widget.color : Colors.white,
              side: BorderSide(width: 2.5, color: widget.color)),
          onPressed: widget.onPressed,
          child: Text(widget.text,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.state ? Colors.white : widget.color)),
        ));
  }
}
