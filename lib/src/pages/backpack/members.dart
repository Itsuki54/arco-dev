import 'package:arco_dev/src/utils/database.dart';
import "package:flutter/material.dart";
// components
import '../../components/common/child_appbar.dart';
import '../../components/backpack/backpack_content_chip.dart';
// pages
import './character_info.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key, required this.uid});

  final String uid;

  @override
  State<MembersPage> createState() => _MemberPage();
}

class _MemberPage extends State<MembersPage> {
  List<Map<String, dynamic>> members = [];
  Database db = Database();

  @override
  void initState() {
    super.initState();
    db.userMembersCollection(widget.uid).all().then((value) {
      setState(() {
        members = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChildAppBar(
          icon: Icon(
            Icons.group,
            size: 45,
            color: Colors.black,
          ),
          title: "メンバー"),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              childAspectRatio: 0.7,
              children: members.map((member) {
                return BackpackContentChip(
                  name: member["name"],
                  level: member["level"] ?? 1,
                  icon: const Icon(Icons.person, size: 45, color: Colors.white),
                  color: Colors.red.shade300,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CharacterInfo(
                              name: member["name"],
                              level: member["level"] ?? 1,
                              description: member["description"] ?? "説明がありません",
                              exp: member["exp"] ?? 0,
                              weapons: member["weapons"] ?? [],
                              memberId: member["id"],
                            )));
                  },
                );
              }).toList())),
    );
  }
}
