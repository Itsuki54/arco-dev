import 'package:arco_dev/src/pages/tutorial/fourth_tutorial.dart';
import 'package:arco_dev/src/utils/colors.dart';
import 'package:flutter/material.dart';

class ThirdTutorialPage extends StatefulWidget {
  const ThirdTutorialPage({super.key, required this.uid});
  final String uid;
  @override
  State<ThirdTutorialPage> createState() => _ThirdTutorialPageState();
}

class _ThirdTutorialPageState extends State<ThirdTutorialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.indigo,
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.navigate_before,
                size: 48.0,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                shape: CircleBorder(),
                padding: EdgeInsets.all(16.0),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FourthTutorialPage(uid: widget.uid),
                  ),
                );
              },
              child: Icon(
                Icons.navigate_next,
                size: 48.0,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                shape: CircleBorder(),
                padding: EdgeInsets.all(16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
