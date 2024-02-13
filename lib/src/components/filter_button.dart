import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({
    super.key,
    required this.text,
    required this.color,
    this.state = false,
  });

  final bool state;
  final String text;
  final Color color;

  @override
  State<FilterButton> createState() => _FilterButton();
}

class _FilterButton extends State<FilterButton> {
  late bool state = widget.state;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(2),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: state ? widget.color : Colors.white,
              side: BorderSide(width: 2.5, color: widget.color)),
          onPressed: () {
            setState(() {
              state = !state;
            });
          },
          child: Text(widget.text,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: state ? Colors.white : widget.color)),
        ));
  }
}
