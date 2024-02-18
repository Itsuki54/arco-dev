import 'package:flutter/material.dart';

// アイコンとページ名のついたNavigation用のボタン
class SquareRouteButton extends StatelessWidget {
  const SquareRouteButton(
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
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => nextPage));
            },
            style: ElevatedButton.styleFrom(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: SizedBox(width: 40, height: 80, child: icon)));
  }
}
