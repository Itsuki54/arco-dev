import "package:flutter/material.dart";
// components
import '../../components/setting_child_appbar.dart';

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolPage();
}

class _ToolPage extends State<ToolsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SettingChildAppBar(
          icon: Icon(
            Icons.home_repair_service,
            size: 45,
            color: Colors.black,
          ),
          title: "Tools"),
      body: Center(),
    );
  }
}
