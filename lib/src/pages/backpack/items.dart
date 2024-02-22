import 'package:arco_dev/src/utils/database.dart';
import "package:flutter/material.dart";
// components
import '../../components/common/child_appbar.dart';
import '../../components/backpack/backpack_content_chip.dart';
// pages
import './item_info.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key, required this.uid});

  final String uid;

  @override
  State<ItemsPage> createState() => _ToolPage();
}

class _ToolPage extends State<ItemsPage> {
  Database db = Database();
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    db.userItemsCollection(widget.uid).all().then((value) {
      setState(() {
        items = value;
      });
    });
    db.usersCollection().update(widget.uid, {"email": "ainznino@pm.me"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChildAppBar(
          icon: Icon(
            Icons.home_repair_service,
            size: 45,
            color: Colors.black,
          ),
          title: "アイテム"),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              childAspectRatio: 0.7,
              children: items.map((item) {
                return BackpackContentChip(
                  name: item["description"],
                  icon:
                      const Icon(Icons.category, size: 45, color: Colors.white),
                  color: Colors.green.shade800,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ItemInfo(
                              name: item["description"],
                              description: item["description"] ?? "説明がありません",
                            )));
                  },
                );
              }).toList())),
    );
  }
}
