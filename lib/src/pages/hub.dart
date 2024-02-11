import 'package:flutter/material.dart';
// pages
import './backpack/backpack.dart';
import './todo/todo.dart';

class Hub extends StatefulWidget {
  Hub({super.key});

  final List<Widget> pages = [
    Scaffold(),
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
      body: widget.pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(
              icon: Icon(Icons.content_paste), label: "ToDo"),
          BottomNavigationBarItem(icon: Icon(Icons.backpack), label: "Backpack")
        ],
        currentIndex: pageIndex,
        onTap: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
