import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// components
import '../../components/simple_route_button.dart';
// pages
import '../settings/settings.dart';
import './party.dart';
import './members.dart';
import './items.dart';
import './weapons.dart';

class BackpackPage extends StatefulWidget {
  const BackpackPage({super.key});

  @override
  State<BackpackPage> createState() => _BackpackPageState();
}

class _BackpackPageState extends State<BackpackPage> {
  int _currentindex = 2;

  void _changeIndex(int value) {
    setState(() {
      _currentindex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(toolbarHeight: 30),
        body: Center(
          child: Column(children: [
            const SimpleRouteButton(
              title: "Party",
              icon: Icon(Icons.assignment_ind, size: 45),
              nextPage: PartyPage(),
            ),
            const SimpleRouteButton(
              title: "Members",
              icon: Icon(Icons.group, size: 45),
              nextPage: MembersPage(),
            ),
            SimpleRouteButton(
              title: "Weapons",
              icon: SvgPicture.asset("assets/images/swords.svg",
                  width: 42,
                  height: 42,
                  theme: const SvgTheme(currentColor: Colors.black)),
              nextPage: WeaponsPage(),
            ),
            const SimpleRouteButton(
              title: "Items",
              icon: Icon(Icons.home_repair_service, size: 45),
              nextPage: ItemsPage(),
            )
          ]),
        ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SettingsPage()));
          },
          child: const Icon(Icons.settings),
        ), // This trailing comma makes auto-formatting nicer for build methods.
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
            BottomNavigationBarItem(
                icon: Icon(Icons.content_paste), label: "ToDo"),
            BottomNavigationBarItem(
                icon: Icon(Icons.backpack), label: "Backpack")
          ],
          currentIndex: _currentindex,
          onTap: _changeIndex,
        ));
  }
}
