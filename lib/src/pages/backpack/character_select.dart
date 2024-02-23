import 'package:arco_dev/src/components/common/child_appbar.dart';
import 'package:arco_dev/src/pages/backpack/character_info.dart';
import 'package:arco_dev/src/utils/database.dart';
import 'package:flutter/material.dart';

class CharacterSelect extends StatefulWidget {
  const CharacterSelect({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  _CharacterSelectState createState() => _CharacterSelectState();
}

class _CharacterSelectState extends State<CharacterSelect> {
  Database db = Database();
  List<Map<String, dynamic>> characters = [];

  @override
  void initState() {
    super.initState();
    db.userMembersCollection(widget.uid).all().then((value) {
      setState(() {
        characters = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChildAppBar(
        title: "キャラクター選択",
        icon: Icon(Icons.person, size: 40),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < characters.length; i++)
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: SizedBox(
                    height: 90,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        Navigator.pop(context, characters[i]);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.person, size: 40),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 5),
                              Text(characters[i]["name"],
                                  style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold)),
                              Text("Lv: ${characters[i]["level"]}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              Text("職業: ${characters[i]["job"]}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
