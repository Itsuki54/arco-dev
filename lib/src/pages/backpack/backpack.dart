import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// components
import '../../components/button/simple_route_button.dart';
// pages
import '../settings/settings.dart';
import './party.dart';
import './members.dart';
import './items.dart';
import './weapons.dart';

class BackpackPage extends StatefulWidget {
  const BackpackPage({super.key});

  @override
  State<BackpackPage> createState() => _BackpackPageState();
}

class _BackpackPageState extends State<BackpackPage> {
  int _currentindex = 2;

  void _changeIndex(int value) {
    setState(() {
      _currentindex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 30),
      body: const Center(
        child: Column(children: [
          SizedBox(height: 40),
          Expanded(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.bluetooth, size: 120),
              SizedBox(height: 20),
              Text("探索中...",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
            ]),
          ),
          SizedBox(height: 40),
          SimpleRouteButton(
            title: "編成",
            icon: Icon(Icons.assignment_ind, size: 45),
            nextPage: PartyPage(),
          ),
          SizedBox(height: 40),
        ]),
      ),
    );
  }
}
