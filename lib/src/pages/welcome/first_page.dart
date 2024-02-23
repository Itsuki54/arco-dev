import 'package:flutter/material.dart';
import './signin_page.dart';
// utils
import 'package:arco_dev/src/utils/colors.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.indigo,
        appBar: AppBar(
          backgroundColor: AppColors.indigo,
          title: const Text("Welcome",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
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
          backgroundColor: AppColors.indigo,
          elevation: 0,
          child: const Icon(
            Icons.navigate_next,
            size: 48.0,
          ),
        ));
  }
}
