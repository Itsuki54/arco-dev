import "package:flutter/material.dart";
// components
import '../../components/setting_child_appbar.dart';

class WeaponsPage extends StatefulWidget {
  const WeaponsPage({super.key});

  @override
  State<WeaponsPage> createState() => _WeaponsPage();
}

class _WeaponsPage extends State<WeaponsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SettingChildAppBar(
          icon: Icon(
            Icons.build,
            size: 45,
            color: Colors.black,
          ),
          title: "Wepons"),
      body: Center(),
    );
  }
}
