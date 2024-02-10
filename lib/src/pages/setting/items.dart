import "package:flutter/material.dart";
// components
import '../../components/setting_child_appbar.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ToolPage();
}

class _ToolPage extends State<ItemsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SettingChildAppBar(
          icon: Icon(
            Icons.home_repair_service,
            size: 45,
            color: Colors.black,
          ),
          title: "Items"),
      body: Center(),
    );
  }
}
