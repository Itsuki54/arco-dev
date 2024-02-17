import 'package:flutter/material.dart';

class HealthViewPage extends StatefulWidget {
  const HealthViewPage({super.key});

  @override
  State<HealthViewPage> createState() => _HealthViewPage();
}

class _HealthViewPage extends State<HealthViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Health",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
