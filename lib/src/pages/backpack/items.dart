import "package:flutter/material.dart";
// components
import '../../components/child_appbar.dart';
import '../../components/backpack_content_chip.dart';
// pages
import './item_info.dart';

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
                  icon:
                      const Icon(Icons.category, size: 45, color: Colors.white),
                  color: Colors.green.shade800,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ItemInfo(
                              name: "疾風剣",
                              description:
                                  "その刀身は煌めく青い光を放ち、鋭利な刃を持つ。この剣は空気を切り裂くような速さで振るわれ、風の力を操ることができる。振るう者の意志に従って風の刃を生み出し、遠くの敵にも届く攻撃を可能にする。疾風剣の真の力は、その扱い手の心の力と結びついており、正しい意図で用いられることでより強力な力を発揮する。",
                            )));
                  },
                ),
            ],
          ),
        )));
  }
}
