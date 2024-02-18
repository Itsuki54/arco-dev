import "package:flutter/material.dart";
// components
import '../../components/common/child_appbar.dart';
import '../../components/backpack/backpack_content_chip.dart';
// pages
import './character_info.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MemberPage();
}

class _MemberPage extends State<MembersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChildAppBar(
          icon: Icon(
            Icons.group,
            size: 45,
            color: Colors.black,
          ),
          title: "Members"),
      body: SingleChildScrollView(
          child: Center(
        child: Wrap(
          spacing: 4,
          runSpacing: 8,
          children: [
            for (int i = 0; i < 32; i++)
              BackpackContentChip(
                name: "キャラ名 $i",
                level: 32,
                icon: const Icon(Icons.person, size: 45, color: Colors.white),
                color: Colors.red.shade300,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CharacterInfo(
                          name: "桜井 雪音",
                          level: 32,
                          description:
                              "和風の世界で生まれ育った若き剣士である。彼女は銀色の髪と氷のような青い目を持ち、優美な美しさと優れた剣術で知られている。雪音は厳しい修行の末に、氷の力を操る特殊な剣術を身につけた。彼女は氷のエネルギーを武器として利用し、敵を凍りつかせる技術を極めている。冷静沈着でありながら、心の中には熱い情熱と義侠心を秘めている。彼女は旅の中で己の力を試し、正義を貫くために戦い続ける。",
                          exp: 0.3)));
                },
              ),
          ],
        ),
      )),
    );
  }
}
