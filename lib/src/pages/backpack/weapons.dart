import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
// components
import '../../components/child_appbar.dart';

class WeaponsPage extends StatefulWidget {
  const WeaponsPage({super.key});

  @override
  State<WeaponsPage> createState() => _WeaponsPage();
}

class _WeaponsPage extends State<WeaponsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChildAppBar(
          icon: SvgPicture.asset("assets/images/swords.svg",
              width: 42,
              height: 42,
              theme: const SvgTheme(currentColor: Colors.black)),
          title: "Wepons"),
      body: Center(),
    );
  }
}
