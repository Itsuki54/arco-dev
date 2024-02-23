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
        appBar: AppBar(backgroundColor: AppColors.indigo),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/appicon.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 80),
              const Text("ようこそ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold))
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
