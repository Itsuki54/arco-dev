import 'package:flutter/material.dart';

class CloseDialogButton extends StatelessWidget {
  const CloseDialogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0.0,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Align(
          alignment: Alignment.topRight,
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.white,
            child: Icon(Icons.close, size: 24, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
