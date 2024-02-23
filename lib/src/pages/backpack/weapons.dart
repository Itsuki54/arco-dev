import 'package:arco_dev/src/utils/database.dart';
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
// components
import '../../components/common/child_appbar.dart';
import '../../components/backpack/backpack_content_chip.dart';
// pages
import './weapon_info.dart';

class WeaponsPage extends StatefulWidget {
  const WeaponsPage({super.key, required this.uid});

  final String uid;

  @override
  State<WeaponsPage> createState() => _WeaponsPage();
}

class _WeaponsPage extends State<WeaponsPage> {
  SvgPicture swordsIcon = SvgPicture.asset("assets/images/swords.svg",
      width: 42, height: 42, theme: const SvgTheme(currentColor: Colors.black));
  List<Map<String, dynamic>> weapons = [];
  Database db = Database();

  @override
  void initState() {
    super.initState();
    db.userWeaponsCollection(widget.uid).all().then((value) {
      setState(() {
        weapons = value;
      });
    });
  }

  /*Future<void> _debugGetWeapons() async {
    final Map<String, dynamic> result =
        await db.weaponsCollection().getRandomDoc("");
    await db.userWeaponsCollection(widget.uid).add(result);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChildAppBar(icon: swordsIcon, title: "武器"),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _debugGetWeapons,
        child: const Icon(Icons.add),
      ),*/
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              childAspectRatio: 0.7,
              children: List.generate(weapons.length, (index) {
                return BackpackContentChip(
                  name: weapons[index]["name"],
                  level: weapons[index]["level"],
                  icon: SvgPicture.asset("assets/images/swords.svg",
                      width: 42,
                      height: 42,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn)),
                  color: Colors.blue.shade800,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WeaponInfo(
                              name: weapons[index]["name"],
                              level: weapons[index]["level"],
                              description:
                                  weapons[index]["description"] ?? "説明なし",
                            )));
                  },
                );
              }))),
    );
  }
}
