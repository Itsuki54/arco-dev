import "package:flutter/material.dart";
// components
import '../../components/child_appbar.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ToolPage();
}

class _ToolPage extends State<ItemsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ChildAppBar(
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
