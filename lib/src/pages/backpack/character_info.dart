import 'package:arco_dev/src/pages/backpack/weapon_select.dart';
import 'package:arco_dev/src/utils/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    this.memberId = "",
    this.party = false,
    this.uid = "",
    this.weapons = const [],
  });

  final String name;
  final int level;
  final String description;
  final double exp;
  final bool party;
  final String uid;
  final String memberId;
  final String characterId;
  final List<Map<String, dynamic>> weapons;

  @override
  State<CharacterInfo> createState() => _CharacterInfo();
}

class _CharacterInfo extends State<CharacterInfo> {
  Database db = Database();
  List<Map<String, dynamic>> weapons = [];

  Future<void> deleteCharacterFromParty() async {
    await db.userPartyCollection(widget.uid).delete(widget.characterId);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      weapons = widget.weapons;
    });
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
                    if (weapons.length > i)
                      BackpackContentChip(
                        name: weapons[i]["name"],
                        level: weapons[i]["level"],
                        icon: SvgPicture.asset("assets/images/swords.svg",
                            width: 42,
                            height: 42,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn)),
                        color: Colors.blue.shade800,
                        onPressed: () {
                          final result =
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => WeaponInfo(
                                        characterId: widget.characterId,
                                        name: weapons[i]["name"],
                                        level: weapons[i]["level"],
                                        description:
                                            weapons[i]["description"] ?? "説明なし",
                                      )));
                          result.then((value) {
                            if (value == "deleted") {
                              db
                                  .userMembersCollection(widget.uid)
                                  .update(widget.memberId, {
                                "weapons": FieldValue.arrayRemove([weapons[i]])
                              }).then((_) {
                                setState(() {
                                  weapons.removeAt(i);
                                });
                              });
                            }
                          });
                        },
                      )
                    else
                      SizedBox(
                          width: 100,
                          height: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                backgroundColor: Colors.grey.shade200),
                            onPressed: () {
                              final result = Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WeaponSelect(uid: widget.uid)));
                              result.then((value) {
                                if (value != null &&
                                    weapons
                                            .map((e) => e["id"])
                                            .contains(value["id"]) ==
                                        false) {
                                  db
                                      .userMembersCollection(widget.uid)
                                      .update(widget.memberId, {
                                    "weapons": FieldValue.arrayUnion([value])
                                  }).then((_) {
                                    setState(() {
                                      weapons.add(value);
                                    });
                                  });
                                }
                              });
                            },
                            child: const Icon(Icons.add, size: 45),
                          )),
                ],
              ),
            ],
          )),
        ));
  }
}
