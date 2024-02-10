import 'package:flutter/material.dart';

// Backpack画面で一覧されるボタン
class BackpackRouteButton extends StatelessWidget {
  const BackpackRouteButton(
      {super.key,
      required this.title,
      required this.icon,
      //required this.onPressed});
      required this.nextPage});

  final String title;
  final Icon icon;
  final Widget nextPage;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => nextPage));
            },
            style: ElevatedButton.styleFrom(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: SizedBox(
                width: 250,
                height: 110,
                child: Row(
                  children: [
                    icon,
                    const SizedBox(width: 32),
                    Text(title,
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold))
                  ],
                ))));
  }
}
