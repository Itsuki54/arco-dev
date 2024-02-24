//import 'package:flutter/material.dart';

//class ShopPage extends StatelessWidget {
//  const ShopPage({Key? key, required this.uid}) : super(key: key);
//  final String uid;
//  @override
//  Widget build(BuildContext context) {
//    return _ShopPage();
//  }
//}
//
//class _ShopPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return DefaultTabController(
//      length: 3,
//      child: Scaffold(
//          appBar: AppBar(
//              title: const Column(children: [
//            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//              Text('Shop Page',
//                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
//              SizedBox(width: 16),
//              Icon(Icons.storefront, size: 48),
//            ]),
//          ])),
//          body: const Column(
//            children: [
//              SizedBox(height: 32),
//              TabBar(tabs: [
//                Tab(
//                    icon: Icon(Icons.restaurant, size: 29),
//                    child: Text("Foods",
//                        style: TextStyle(fontWeight: FontWeight.bold))),
//                Tab(
//                    icon: Icon(Icons.build, size: 29),
//                    child: Text("Wepons",
//                        style: TextStyle(fontWeight: FontWeight.bold))),
//                Tab(
//                    icon: Icon(Icons.support_agent, size: 29),
//                    child: Text("Services",
//                        style: TextStyle(fontWeight: FontWeight.bold))),
//              ]),
//              TabBarView(children: [
//                Icon(Icons.abc),
//                Icon(Icons.abc),
//                Icon(Icons.abc),
//              ])
//            ],
//          )),
//    );
//  }
//}
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key, required this.uid});

  final String uid;

  @override
  State<ShopPage> createState() => _ShopPage();
}

class _ShopPage extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('Shop',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.storefront, size: 42),
          ]),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                  icon: Icon(Icons.restaurant, size: 29),
                  child: Text("Foods",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Tab(
                  icon: Icon(Icons.build, size: 29),
                  child: Text("Wepons",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Tab(
                  icon: Icon(Icons.support_agent, size: 29),
                  child: Text("Services",
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text("It's cloudy here"),
            ),
            Center(
              child: Text("It's rainy here"),
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      ),
    );
  }
}
