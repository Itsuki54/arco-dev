import 'package:arco_dev/src/pages/backpack/items.dart';
import 'package:arco_dev/src/pages/backpack/members.dart';
import 'package:arco_dev/src/pages/backpack/weapons.dart';
import 'package:arco_dev/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
// components
import '../../components/button/square_route_button.dart';
import '../../components/common/child_appbar.dart';
import '../../components/button/party_route_button.dart';
// pages
import './character_info.dart';
// utils
import 'package:arco_dev/src/utils/database.dart';

// キャラクターのクラス
//class Character {
//  const Character({
//    required this.attribute,
//    required this.description,
//    required this.image,
//    required this.job,
//    required this.level,
//    required this.name,
//    required this.rarity,
//    required this.status,
//    required this.exp,
//  });
//
//  final String attribute;
//  final String description;
//  final dynamic image;
//  final String job;
//  final int level;
//  final String name;
//  final int rarity;
//  final Map<String, int> status;
//  final int exp;
//}

class PartyPage extends StatefulWidget {
  const PartyPage({super.key, required this.uid});

  final String uid;

  @override
  State<PartyPage> createState() => _PartyPage();
}

class _PartyPage extends State<PartyPage> {
  List<Map<String, dynamic>> characters = [];
  Database db = Database();

  // partyのデータを取得する
  Future<void> getMembers() async {
    db.userMembersCollection(widget.uid).all().then((value) {
      setState(() {
        characters = value;
      });
    });
  }

  // パーティへメンバーを追加
  Future<void> addMembers(Map<String, dynamic> data) async {
    db.userMembersCollection(widget.uid).add(data);
  }

  // パーティのメンバーを削除
  Future<void> deleteMember(String key) async {
    db.userMembersCollection(widget.uid).delete(key);
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
            const SizedBox(height: 32),
            SingleChildScrollView(
                child: Column(
              children: [
                for (int i = 0; i < characters.length; i++)
                  PartyRouteButton(
                    title: characters[i]['name'],
                    icon: characters[i]['image'],
                    level: characters[i]['level'],
                    job: characters[i]['job'],
                    nextPage: CharacterInfo(
                        name: characters[i]['name'],
                        level: characters[i]['level'],
                        description: characters[i]['description'],
                        exp: characters[i]['exp']),
                  ),
              ],
            )),
            const Expanded(child: SizedBox()),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.indigo),
                onPressed: characters.isEmpty ? () {} : null,
                child: const SizedBox(
                  height: 48,
                  width: 250,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "パーティを追加",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ]),
                )),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
