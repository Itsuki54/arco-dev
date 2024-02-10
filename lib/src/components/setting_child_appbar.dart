import 'package:flutter/material.dart';

class SettingChildAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SettingChildAppBar({
    super.key,
    required this.icon,
    required this.title,
  });

  final Icon icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 150,
      leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          }),
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
