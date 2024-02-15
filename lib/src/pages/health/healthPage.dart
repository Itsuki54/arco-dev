import 'package:flutter/material.dart';

import '../../components/user_status.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});
  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: UserStatus(),
    );
  }
}
