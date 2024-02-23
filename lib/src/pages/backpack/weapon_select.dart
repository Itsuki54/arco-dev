import 'package:arco_dev/src/components/common/child_appbar.dart';
import 'package:arco_dev/src/utils/colors.dart';
import 'package:arco_dev/src/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeaponSelect extends StatefulWidget {
  const WeaponSelect({super.key, required this.uid});

  final String uid;

  @override
  State<WeaponSelect> createState() => _WeaponSelect();
}

class _WeaponSelect extends State<WeaponSelect> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChildAppBar(
        title: "武器選択",
        icon: SvgPicture.asset("assets/images/swords.svg",
            width: 40,
            height: 40,
            colorFilter: ColorFilter.mode(AppColors.indigo, BlendMode.srcIn)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < weapons.length; i++)
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, weapons[i]);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/images/swords.svg",
                            width: 42,
                            height: 42,
                            colorFilter: ColorFilter.mode(
                                AppColors.indigo, BlendMode.srcIn)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weapons[i]["name"],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "レベル: ${weapons[i]["level"]}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
