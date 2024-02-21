import 'package:arco_dev/src/utils/colors.dart';
import 'package:flutter/material.dart';

import '../welcome/signin_page.dart';

class SecondTutorialPage extends StatefulWidget {
  const SecondTutorialPage({Key? key}) : super(key: key);

  @override
  State<SecondTutorialPage> createState() => _SecondTutorialPageState();
}

class _SecondTutorialPageState extends State<SecondTutorialPage> {
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
                  'データの連携には\nHealth Connectと\nGoogle Fitが必要です',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () => {},
                        child: null,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the value as needed
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height:
                          18, // Add some spacing between the button and text
                    ),
                    Text(
                      'タップしてインストール',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () => {},
                        child: null,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the value as needed
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height:
                          18, // Add some spacing between the button and text
                    ),
                    Text(
                      'タップしてインストール',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
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
