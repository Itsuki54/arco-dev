import 'package:flutter/material.dart';
import './signin_page.dart';

Color backgroundColorGray = const Color(0xFF363636);

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColorGray,
        appBar: AppBar(
          backgroundColor: backgroundColorGray,
          title: const Text("Welcome"),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/images/appicon.png',
                  width: 300,
                  height: 300,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()),
            );
          },
          child: Icon(
            Icons.navigate_next,
            size: 48.0,
          ),
          backgroundColor: backgroundColorGray,
          elevation: 0,
        ));
  }
}
