import 'package:arco_dev/src/utils/colors.dart';
import 'package:flutter/material.dart';

import '../welcome/signin_page.dart';

class FourthTutorialPage extends StatefulWidget {
  const FourthTutorialPage({Key? key}) : super(key: key);

  @override
  State<FourthTutorialPage> createState() => _FourthTutorialPageState();
}

class _FourthTutorialPageState extends State<FourthTutorialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.indigo,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '健康状態',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mi bandと連携する場合、\nMi Fitness または Zepp Lifeの\nGoogle Fit連携が必要です',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
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
        elevation: 0,
      ),
    );
  }
}
