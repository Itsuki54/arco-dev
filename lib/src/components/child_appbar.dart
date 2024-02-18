import 'package:flutter/material.dart';

// Backpackから派生する画面で共通しているAppBar
class ChildAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChildAppBar({
    super.key,
    required this.icon,
    required this.title,
  });

  final dynamic icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 150,
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.all(5),
          child: icon,
        )
      ],
    );
  }

  // AppBarのWidgetを作る時は、下の記述が必要らしい
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
