import "package:flutter/material.dart";
// components
import '../../components/backpack_child_appbar.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MemberPage();
}

class _MemberPage extends State<MembersPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SettingChildAppBar(
          icon: Icon(
            Icons.group,
            size: 45,
            color: Colors.black,
          ),
          title: "Members"),
      body: Center(),
    );
  }
}
