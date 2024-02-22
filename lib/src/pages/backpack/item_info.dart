import 'package:flutter/material.dart';
// componets
// pages

class ItemInfo extends StatefulWidget {
  const ItemInfo({
    super.key,
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  @override
  State<ItemInfo> createState() => _ItemInfo();
}

class _ItemInfo extends State<ItemInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
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
