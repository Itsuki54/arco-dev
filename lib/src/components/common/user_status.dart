import 'package:flutter/material.dart';
// componets
import './exp_bar.dart';

class UserStatus extends StatefulWidget {
  const UserStatus({
    super.key,
    this.steps = 1000,
    this.distance = 1.0,
    this.level = 1,
    this.exp = 0.1,
  });

  final int steps;
  final double distance;
  final int level;
  final double exp;

  @override
  State<UserStatus> createState() => _UserStatus();
}

class _UserStatus extends State<UserStatus> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        height: 180,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: Colors.grey.shade200,
          child: Container(
            padding: const EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Steps: ${widget.steps}",
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              Text("${widget.distance}km",
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              const Expanded(child: SizedBox()),
              ExpBar(
                  expValue: widget.exp,
                  width: 240,
                  height: 10,
                  color: Colors.green),
              Text("lv: ${widget.level}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
            ]),
          ),
        ));
  }
}
