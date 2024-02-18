import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// components
import '../../components/common/child_appbar.dart';
import '../../components/button/simple_route_button.dart';
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
          /*SimpleRouteButton(
              title: "Visibility",
              icon: const Icon(Icons.visibility, size: 45),
              nextPage: Scaffold(
                appBar: AppBar(),
              )),*/
          SimpleRouteButton(
              title: "Battle",
              //icon: const Icon(Icons.grain, size: 45),
              icon: SvgPicture.asset("assets/images/swords.svg",
                  width: 42,
                  height: 42,
                  theme: const SvgTheme(currentColor: Colors.black)),
              nextPage: Scaffold(appBar: AppBar())),
          Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Scaffold(
                              appBar: AppBar(),
                            )));
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: SizedBox(
                      width: 250,
                      height: 110,
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            size: 45,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(width: 32),
                          Text("Delete",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade400)),
                          const Expanded(child: SizedBox()),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      )))),
        ]),
      ),
    );
  }
}
