import 'package:arco_dev/src/pages/tutorial/first_tutorial.dart';
import 'package:arco_dev/src/pages/welcome/signin_page.dart';
import 'package:arco_dev/src/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// components
import '../../components/common/child_appbar.dart';
import '../../components/button/simple_route_button.dart';
// pages
import 'profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const ChildAppBar(
            title: "設定", icon: Icon(Icons.settings, size: 40)),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SimpleRouteButton(
                      title: "プロフィール",
                      icon: const Icon(Icons.person, size: 40),
                      nextPage: ProfilePage(uid: widget.uid)),
                  SimpleRouteButton(
                      title: "戦闘",
                      //icon: const Icon(Icons.grain, size: 45),
                      icon: SvgPicture.asset("assets/images/swords.svg",
                          width: 42,
                          height: 42,
                          theme: SvgTheme(currentColor: AppColors.indigo)),
                      nextPage: Scaffold(appBar: AppBar())),
                  SimpleRouteButton(
                      title: "チュートリアル",
                      icon: const Icon(Icons.person, size: 40),
                      nextPage: FirstTutorialPage(uid: widget.uid)),
                  const SimpleRouteButton(
                      title: "ライセンス",
                      icon: Icon(Icons.account_balance, size: 40),
                      nextPage: LicensePage(
                          applicationName: "アルコ",
                          applicationVersion: "1.0.0",
                          applicationLegalese: "© 2024 和塗り")),
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                          onPressed: () {
                            _auth.signOut().then((value) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInPage()));
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
        ));
  }
}
