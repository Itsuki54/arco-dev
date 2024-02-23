import 'package:arco_dev/src/pages/backpack/character_select.dart';
import 'package:arco_dev/src/pages/backpack/items.dart';
import 'package:arco_dev/src/pages/backpack/members.dart';
import 'package:arco_dev/src/pages/backpack/weapons.dart';
import 'package:arco_dev/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// components
import '../../components/button/square_route_button.dart';
import '../../components/common/child_appbar.dart';
import '../../components/button/party_route_button.dart';
// pages
import './character_info.dart';
// utils
import 'package:arco_dev/src/utils/database.dart';

class PartyPage extends StatefulWidget {
  const PartyPage({super.key, required this.uid});

  final String uid;

  @override
  State<PartyPage> createState() => _PartyPage();
}

// キャラクターの仮のクラス
class Character {
  Character({
    this.exp = 0,
    required this.icon,
    required this.name,
    required this.level,
    required this.job,
    required this.id,
    this.partyId,
    this.description = "",
  });
  int? exp;
  Icon icon;
  String name;
  int level;
  String job;
  String id;
  String? partyId;
  String description = "";
}

class _PartyPage extends State<PartyPage> {
  // キャラクター
  List<Character> characters = [];

  Database db = Database();

  // partyのデータを取得する
  Future<void> getMembers() async {
    List<Map<String, dynamic>> data =
        await db.userPartyCollection(widget.uid).all();
    List<Map<String, dynamic>> members = await Future.wait(data.map((e) async {
      return await db.userMembersCollection(widget.uid).findById(e["memberId"]);
    }));
    for (int i = 0; i < members.length; i++) {
      setState(() {
        characters.add(Character(
          partyId: data[i]["id"],
          id: members[i]["id"],
          icon: const Icon(Icons.person, size: 45),
          name: members[i]["name"],
          level: members[i]["level"],
          job: members[i]["job"],
          description: members[i]["description"],
        ));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChildAppBar(
          icon: Icon(
            Icons.assignment_ind,
            size: 42,
            color: Colors.black,
          ),
          title: "編成"),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SquareRouteButton(
                      title: "メンバー",
                      icon: const Icon(Icons.group, size: 45),
                      nextPage: MembersPage(uid: widget.uid)),
                  SquareRouteButton(
                      title: "武器",
                      icon: SvgPicture.asset("assets/images/swords.svg",
                          width: 42,
                          height: 42,
                          theme: SvgTheme(currentColor: AppColors.indigo)),
                      nextPage: WeaponsPage(uid: widget.uid)),
                  SquareRouteButton(
                      title: "アイテム",
                      icon: const Icon(Icons.home_repair_service, size: 45),
                      nextPage: ItemsPage(uid: widget.uid)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            for (int i = 0; i < 4; i++)
              if (characters.length > i)
                PartyRouteButton(
                  title: characters[i].name,
                  icon: characters[i].icon,
                  level: characters[i].level,
                  job: characters[i].job,
                  onPressed: () {
                    final result = Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CharacterInfo(
                              name: characters[i].name,
                              level: characters[i].level,
                              description: characters[i].description != ""
                                  ? characters[i].description
                                  : "",
                              exp: characters[i].exp != null
                                  ? characters[i].exp!.toDouble()
                                  : 0,
                              party: true,
                              characterId: characters[i].partyId!,
                              uid: widget.uid,
                            )));
                    result.then((value) {
                      if (value == "deleted") {
                        setState(() {
                          characters.removeAt(i);
                        });
                      }
                    });
                  },
                )
              else
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              final result = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CharacterSelect(uid: widget.uid)));
                              result.then((value) {
                                if (value != null &&
                                    characters
                                            .map((e) => e.id)
                                            .toList()
                                            .contains(value["id"]) ==
                                        false) {
                                  db.userPartyCollection(widget.uid).add(
                                      {...value, "memberId": value["id"]}).then(
                                    (_) {
                                      setState(() {
                                        characters.add(Character(
                                            id: value["id"],
                                            partyId: _.id,
                                            icon: const Icon(Icons.person,
                                                size: 45),
                                            name: value["name"],
                                            level: value["level"],
                                            job: value["job"]));
                                      });
                                    },
                                  );
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const SizedBox(
                                width: 120,
                                height: 120,
                                child: Icon(Icons.add, size: 60))))),
          ],
        ),
      ),
    );
  }
}
