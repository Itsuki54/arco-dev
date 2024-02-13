import 'package:flutter/material.dart';
// pages
import './backpack/backpack.dart';
import './todo/todo.dart';
import './map/map.dart';

class Hub extends StatefulWidget {
  Hub({super.key});

  final List<Widget> pages = [
    MapPage(),
    ToDoPage(),
    BackpackPage(),
    Scaffold(),
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
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.map), label: "Map"),
          NavigationDestination(icon: Icon(Icons.content_paste), label: "ToDo"),
          NavigationDestination(icon: Icon(Icons.backpack), label: "Backpack"),
          NavigationDestination(
              icon: Icon(Icons.bluetooth), label: "Bluetooth"),
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
