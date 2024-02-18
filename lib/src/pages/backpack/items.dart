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
          title: "アイテム"),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              childAspectRatio: 0.7,
              children: List.generate(32, (index) {
                return BackpackContentChip(
                  name: "アイテム名 $index",
                  level: 32,
                  icon:
                      const Icon(Icons.category, size: 45, color: Colors.white),
                  color: Colors.green.shade800,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ItemInfo(
                              name: "煌火の玉",
                              description:
                                  "　煌火の玉は、神秘的な力を秘めた宝石である。その表面は燃え盛る炎のように輝き、中には無限の熱源が宿っていると伝えられている。持ち主が願いを込めることで、周囲の空間を暖かく照らし、また炎を発生させることができる。この玉は冒険者や魔術師にとって、夜間の旅路や冷たい場所での生存に不可欠な存在である。しかし、その力を過度に使うと、周囲に災厄を招くこともあると言われている。",
                            )));
                  },
                );
              }))),
    );
  }
}
