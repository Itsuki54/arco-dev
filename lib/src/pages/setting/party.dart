import 'package:flutter/material.dart';
// components
import '../../components/setting_child_appbar.dart';

class PartyPage extends StatefulWidget {
  const PartyPage({super.key});

  @override
  State<PartyPage> createState() => _PartyPage();
}

class _PartyPage extends State<PartyPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SettingChildAppBar(
          icon: Icon(
            Icons.assignment_ind,
            size: 45,
            color: Colors.black,
          ),
          title: "Party"),
      body: Center(),
    );
  }
}
