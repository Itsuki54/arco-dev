import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
// components
import '../../components/child_appbar.dart';
import '../../components/backpack_content_chip.dart';
// pages
import './weapon_info.dart';

class WeaponsPage extends StatefulWidget {
  const WeaponsPage({super.key});

  @override
  State<WeaponsPage> createState() => _WeaponsPage();
}

class _WeaponsPage extends State<WeaponsPage> {
  SvgPicture swordsIcon = SvgPicture.asset("assets/images/swords.svg",
      width: 42, height: 42, theme: const SvgTheme(currentColor: Colors.black));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ChildAppBar(icon: swordsIcon, title: "Wepons"),
        body: SingleChildScrollView(
            child: Center(
          child: Wrap(
            spacing: 4,
            runSpacing: 8,
            children: [
              for (int i = 0; i < 32; i++)
                BackpackContentChip(
                  name: "武器名 $i",
                  level: 32,
                  icon: SvgPicture.asset("assets/images/swords.svg",
                      width: 42,
                      height: 42,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn)),
                  color: Colors.blue.shade800,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => WeaponInfo()));
                  },
                ),
            ],
          ),
        )));
  }
}
