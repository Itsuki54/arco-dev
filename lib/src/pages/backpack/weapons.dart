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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const WeaponInfo(
                              name: "疾風剣",
                              level: 32,
                              description:
                                  "その刀身は煌めく青い光を放ち、鋭利な刃を持つ。この剣は空気を切り裂くような速さで振るわれ、風の力を操ることができる。振るう者の意志に従って風の刃を生み出し、遠くの敵にも届く攻撃を可能にする。疾風剣の真の力は、その扱い手の心の力と結びついており、正しい意図で用いられることでより強力な力を発揮する。",
                            )));
                  },
                ),
            ],
          ),
        )));
  }
}
