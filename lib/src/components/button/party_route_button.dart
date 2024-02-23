import 'package:flutter/material.dart';

class PartyRouteButton extends StatelessWidget {
  const PartyRouteButton(
      {super.key,
      required this.title,
      required this.icon,
      required this.level,
      required this.job,
      required this.onPressed});

  final String title;
  final Icon icon;
  final int level;
  final String job;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const TextStyle propertyTextStyle =
        TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: SizedBox(
                width: 280,
                height: 110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    icon,
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5),
                        Text(title,
                            style: const TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold)),
                        Text("Lv: $level", style: propertyTextStyle),
                        Text("職業: $job", style: propertyTextStyle),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ))));
  }
}
