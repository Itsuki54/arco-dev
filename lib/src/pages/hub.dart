import 'package:flutter/material.dart';
// pages
import './backpack/backpack.dart';
import './todo/todo.dart';
import './map/map.dart';
import 'battle/battle.dart';

class Hub extends StatefulWidget {
  Hub({super.key});

  final List<Widget> pages = [
    MapPage(),
    ToDoPage(),
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
        appBar: AppBar(title: const Text("Battle Sample")),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => BattlePage()));
              },
              child: const Text("Jump to the Battle Sample"),
            )
          ]),
        ));
    //return Scaffold(
    //  body: widget.pages[pageIndex],
    //  bottomNavigationBar: NavigationBar(
    //    destinations: const <Widget>[
    //      NavigationDestination(icon: Icon(Icons.map), label: "Map"),
    //      NavigationDestination(icon: Icon(Icons.content_paste), label: "ToDo"),
    //      NavigationDestination(icon: Icon(Icons.backpack), label: "Backpack")
    //    ],
    //    selectedIndex: pageIndex,
    //    onDestinationSelected: (int index) {
    //      setState(() {
    //        pageIndex = index;
    //      });
    //    },
    //  ),
    //);
  }
}
