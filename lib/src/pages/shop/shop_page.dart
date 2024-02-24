import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  Widget build(BuildContext context) {
    return _ShopPage();
  }
}

class _ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: const Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('Shop Page',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(width: 16),
            Icon(Icons.storefront, size: 48),
          ]),
        ])),
        body: Column(children: [
          TabBarView(
            children: [
              TabBar(tabs: [
                Tab(
                    icon: Icon(Icons.restaurant, size: 29),
                    child: Text("Foods")),
                Tab(
                    icon: Icon(Icons.build, size: 29),
                    child: Text("Tools & Wepons")),
                Tab(
                    icon: Icon(Icons.support_agent, size: 29),
                    child: Text("Services")),
              ]),
            ],
          )
        ]),
      ),
    );
  }
}
