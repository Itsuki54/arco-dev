import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// components
import '../../components/exp_bar.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
          toolbarHeight: 250,
          flexibleSpace: Column(
            children: [
              const SizedBox(height: 64),
              SizedBox(
                  width: 300,
                  height: 180,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Colors.grey.shade200,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Steps: 10000",
                                style: const TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold)),
                            Text("1km",
                                style: const TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold)),
                            const Expanded(child: SizedBox()),
                            ExpBar(
                                expValue: 0.1,
                                width: 240,
                                height: 10,
                                color: Colors.green),
                            Text("lv: 1",
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                          ]),
                    ),
                  ))
            ],
          ),
          bottom: TabBar(unselectedLabelColor: Colors.grey.shade500, tabs: [
            Tab(icon: Icon(Icons.today), child: Text("Daily")),
            Tab(icon: Icon(Icons.view_week), child: Text("Weekly")),
            Tab(icon: Icon(Icons.calendar_month), child: Text("Monthly")),
          ]),
        )));
  }
}
