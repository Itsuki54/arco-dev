import 'package:flutter/material.dart';

// components
import '../../components/button/simple_route_button.dart';
import '../../components/common/ripples.dart';
// pages
import './party.dart';

class BackpackPage extends StatefulWidget {
  const BackpackPage({super.key, required this.uid});

  final String uid;

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
      body: Center(
        child: Column(children: [
          const SizedBox(height: 40),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                        alignment: Alignment(0, 0),
                        child: SizedBox(
                            height: 250, width: 250, child: WaterRipple())),
                    Align(
                        alignment: Alignment(0, 0),
                        child: Icon(
                          Icons.bluetooth,
                          size: 120,
                        )),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "探索中...",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SimpleRouteButton(
            title: "編成",
            icon: const Icon(Icons.assignment_ind, size: 45),
            nextPage: PartyPage(uid: widget.uid),
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }
}
