import "package:flutter/material.dart";
// components
import '../../components/child_appbar.dart';
import '../../components/backpack_content_chip.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ToolPage();
}

class _ToolPage extends State<ItemsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const ChildAppBar(
            icon: Icon(
              Icons.home_repair_service,
              size: 45,
              color: Colors.black,
            ),
            title: "Items"),
        body: SingleChildScrollView(
            child: Center(
          child: Wrap(
            spacing: 4,
            runSpacing: 8,
            children: [
              for (int i = 0; i < 32; i++)
                BackpackContentChip(
                    name: "アイテム名 $i",
                    level: 32,
                    icon: const Icon(Icons.category,
                        size: 45, color: Colors.white),
                    color: Colors.green.shade800),
            ],
          ),
        )));
  }
}
