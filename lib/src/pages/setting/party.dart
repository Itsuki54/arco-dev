import 'package:flutter/material.dart';
// components
import '../../components/setting_child_appbar.dart';
import '../../components/party_route_button.dart';

class PartyPage extends StatefulWidget {
  const PartyPage({super.key});

  @override
  State<PartyPage> createState() => _PartyPage();
}

class _PartyPage extends State<PartyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingChildAppBar(
          icon: Icon(
            Icons.assignment_ind,
            size: 42,
            color: Colors.black,
          ),
          title: "Party"),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 32),
            PartyRouteButton(
                title: "キャラクター名",
                icon: const Icon(Icons.person_outline, size: 45),
                level: 45,
                job: "警察官",
                nextPage: Scaffold(appBar: AppBar()))
          ],
        ),
      ),
    );
  }
}
