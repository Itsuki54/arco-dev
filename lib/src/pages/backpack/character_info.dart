import 'package:arco_dev/src/utils/database.dart';
import 'package:flutter/material.dart';
import "package:flutter_svg/flutter_svg.dart";
// componets
import '../../components/common/exp_bar.dart';
import '../../components/backpack/backpack_content_chip.dart';
// pages
import './weapon_info.dart';

class CharacterInfo extends StatefulWidget {
  const CharacterInfo({
    super.key,
    required this.name,
    required this.level,
    required this.description,
    required this.exp,
    this.characterId = "",
    this.party = false,
    this.uid = "",
  });

  final String name;
  final int level;
  final String description;
  final double exp;
  final bool party;
  final String uid;
  final String characterId;

  @override
  State<CharacterInfo> createState() => _CharacterInfo();
}

class _CharacterInfo extends State<CharacterInfo> {
  Database db = Database();

  Future<void> deleteCharacterFromParty() async {
    await db.userPartyCollection(widget.uid).delete(widget.characterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            if (widget.party)
              IconButton(
                  onPressed: () {
                    deleteCharacterFromParty().then((value) {
                      Navigator.pop(context, "deleted");
                    });
                  },
                  icon: const Icon(Icons.delete, size: 32))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset("assets/images/appicon.png"),
              ),
              const SizedBox(height: 42),
              Text(
                widget.name,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text("Lv: ${widget.level}",
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ExpBar(
                expValue: 0.1,
                width: 250,
                height: 13,
                color: Colors.green,
              ),
              const SizedBox(height: 32),
              SizedBox(
                  width: 280,
                  child: SingleChildScrollView(
                      child: Flexible(
                          child: Text(
                    widget.description,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )))),
              const SizedBox(height: 42),
              const Text("装備",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 28),
              Wrap(
                spacing: 4,
                runSpacing: 8,
                children: [
                  for (int i = 0; i < 3; i++)
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
            ],
          )),
        ));
  }
}
