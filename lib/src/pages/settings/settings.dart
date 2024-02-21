import 'package:arco_dev/src/pages/welcome/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// components
import '../../components/common/child_appbar.dart';
import '../../components/button/simple_route_button.dart';
// pages
import 'profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.uid});

  final String uid;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const ChildAppBar(title: "設定", icon: Icon(Icons.settings, size: 40)),
      body: Center(
        child: Column(children: [
          SimpleRouteButton(
              title: "プロフィール",
              icon: const Icon(Icons.person, size: 40),
              nextPage: const ProfilePage()),
          SimpleRouteButton(
              title: "戦闘",
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
                    _auth.signOut().then((value) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SignInPage()));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: SizedBox(
                      width: 250,
                      height: 90,
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            size: 40,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(width: 16),
                          Text("ログアウト",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade400)),
                          const Expanded(child: SizedBox()),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      )))),
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
                      height: 90,
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            size: 40,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(width: 16),
                          Text("データ削除",
                              style: TextStyle(
                                  fontSize: 24,
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
