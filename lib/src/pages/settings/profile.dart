import 'package:flutter/material.dart';

// components
import '../../components/common/child_appbar.dart';
// pages

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const ChildAppBar(title: "設定", icon: Icon(Icons.settings, size: 40)),
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/sample_icon.png',
                width: 100, height: 100, fit: BoxFit.cover),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("名前:"),
                Text("ID:"),
                Text("レベル:"),
                Text("経験値:"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
