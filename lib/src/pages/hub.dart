import 'package:arco_dev/src/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './backpack/backpack.dart';
import './todo/todo.dart';
import './map/map.dart';

class Hub extends StatefulWidget {
  Hub({super.key});

  final List<Widget> pages = [
    MapPage(),
    HomePage(),
    BackpackPage(),
  ];

  @override
  State<Hub> createState() => _Hub();
}

class _Hub extends State<Hub> {
  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.pages[pageIndex],
      bottomNavigationBar: NavigationBar(
        destinations: <Widget>[
          const NavigationDestination(icon: Icon(Icons.map), label: "地図"),
          const NavigationDestination(icon: Icon(Icons.home), label: "ホーム"),
          NavigationDestination(
              icon: SvgPicture.asset("assets/images/swords.svg", width: 24),
              label: "戦闘")
        ],
        selectedIndex: pageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
