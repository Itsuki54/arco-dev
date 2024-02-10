import 'package:flutter/material.dart';
// components
import '../../components/setting_child_appbar.dart';
import '../../components/party_route_button.dart';

class PartyPage extends StatefulWidget {
  const PartyPage({super.key});

  @override
  State<PartyPage> createState() => _PartyPage();
}

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingChildAppBar(
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
                  nextPage: Scaffold(appBar: AppBar())),
          ],
        ),
      ),
    );
  }
}
