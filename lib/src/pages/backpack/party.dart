import 'package:flutter/material.dart';
// components
import '../../components/child_appbar.dart';
import '../../components/party_route_button.dart';
// pages
import './character_info.dart';

class PartyPage extends StatefulWidget {
  const PartyPage({super.key});

  @override
  State<PartyPage> createState() => _PartyPage();
}

// キャラクターの仮のクラス
class Character {
  Character({
    required this.icon,
    required this.name,
    required this.level,
    required this.job,
  });
  Icon icon;
  String name;
  int level;
  String job;
}

class _PartyPage extends State<PartyPage> {
  // キャラクターのダミーデータ
  List<Character> characters = [
    Character(
        icon: const Icon(Icons.assignment_ind, size: 42, color: Colors.black),
        name: "高橋 真琴",
        level: 10,
        job: "忍者"),
    Character(
        icon: const Icon(Icons.assignment_ind, size: 42, color: Colors.black),
        name: "竹内 悠斗",
        level: 8,
        job: "武士"),
    Character(
        icon: const Icon(Icons.assignment_ind, size: 42, color: Colors.black),
        name: "望月 美咲",
        level: 12,
        job: "妖術師"),
    Character(
        icon: const Icon(Icons.assignment_ind, size: 42, color: Colors.black),
        name: " 岡田 龍之介",
        level: 6,
        job: "茶道士兼剣術家"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChildAppBar(
          icon: Icon(
            Icons.assignment_ind,
            size: 42,
            color: Colors.black,
          ),
          title: "Party"),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 32),
            for (int i = 0; i < characters.length; i++)
              PartyRouteButton(
                title: characters[i].name,
                icon: characters[i].icon,
                level: characters[i].level,
                job: characters[i].job,
                nextPage: CharacterInfo(
                    name: "桜井 雪音",
                    level: 32,
                    description:
                        "和風の世界で生まれ育った若き剣士である。彼女は銀色の髪と氷のような青い目を持ち、優美な美しさと優れた剣術で知られている。雪音は厳しい修行の末に、氷の力を操る特殊な剣術を身につけた。彼女は氷のエネルギーを武器として利用し、敵を凍りつかせる技術を極めている。冷静沈着でありながら、心の中には熱い情熱と義侠心を秘めている。彼女は旅の中で己の力を試し、正義を貫くために戦い続ける。",
                    exp: 0.3),
              ),
          ],
        ),
      ),
    );
  }
}
