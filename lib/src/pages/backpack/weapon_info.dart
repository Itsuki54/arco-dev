import 'package:flutter/material.dart';

class WeaponInfo extends StatefulWidget {
  const WeaponInfo({
    super.key,
    required this.name,
    required this.level,
    required this.description,
    this.uid = "",
    this.characterId = "",
  });

  final String name;
  final int level;
  final String description;
  final String uid;
  final String characterId;

  @override
  State<WeaponInfo> createState() => _WeaponInfo();
}

class _WeaponInfo extends State<WeaponInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            if (widget.characterId != "")
              IconButton(
                  onPressed: () {
                    Navigator.pop(context, "deleted");
                  },
                  icon: const Icon(Icons.delete, size: 32))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset("assets/images/appicon.png"),
              ),
              const SizedBox(height: 42),
              Text(
                widget.name,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text("Lv: ${widget.level}",
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              SizedBox(
                  width: 280,
                  child: SingleChildScrollView(
                      child: Flexible(
                          child: Text(
                    widget.description,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )))),
            ],
          )),
        ));
  }
}
