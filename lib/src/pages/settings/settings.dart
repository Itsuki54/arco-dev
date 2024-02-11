import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// components
import '../../components/child_appbar.dart';
import '../../components/simple_route_button.dart';
// pages

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChildAppBar(
          title: "Settings", icon: Icon(Icons.settings, size: 45)),
      body: Center(
        child: Column(children: [
          SimpleRouteButton(
              title: "Profile",
              icon: const Icon(Icons.person, size: 45),
              nextPage: Scaffold(
                appBar: AppBar(),
              )),
          SimpleRouteButton(
              title: "Visibility",
              icon: const Icon(Icons.visibility, size: 45),
              nextPage: Scaffold(
                appBar: AppBar(),
              )),
          SimpleRouteButton(
              title: "Battle",
              //icon: const Icon(Icons.grain, size: 45),
              icon: SvgPicture.asset("assets/images/swords.svg",
                  width: 42,
                  height: 42,
                  theme: const SvgTheme(currentColor: Colors.black)),
              nextPage: Scaffold(appBar: AppBar())),
        ]),
      ),
    );
  }
}
