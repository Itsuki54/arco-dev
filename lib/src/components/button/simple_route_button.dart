import 'package:flutter/material.dart';

// アイコンとページ名のついたNavigation用のボタン
class SimpleRouteButton extends StatelessWidget {
  const SimpleRouteButton(
      {super.key,
      required this.title,
      required this.icon,
      //required this.onPressed});
      required this.nextPage});

  final String title;
  final dynamic icon;
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
                height: 90,
                child: Row(
                  children: [
                    icon,
                    const SizedBox(width: 16),
                    Text(title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const Expanded(child: SizedBox()),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ))));
  }
}
