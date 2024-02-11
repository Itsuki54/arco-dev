import "package:flutter/material.dart";
// components
import '../../components/child_appbar.dart';
import '../../components/backpack_content_chip.dart';
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CharacterInfo()));
                },
              ),
          ],
        ),
      )),
    );
  }
}
