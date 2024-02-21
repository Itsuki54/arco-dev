import 'package:flutter/material.dart';

class HealthContentButton extends StatelessWidget {
  const HealthContentButton({
    super.key,
    required this.title,
    required this.text,
    required this.iconImage,
    required this.color,
    required this.onPressed,
  });

  final Color color;
  final dynamic iconImage;
  final String title;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        child: SizedBox(
          width: 180,
          height: 160,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: onPressed,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: iconImage,
                      ),
                      const SizedBox(width: 4),
                      Text(title,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: color))
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                ],
              )),
        ));
  }
}
