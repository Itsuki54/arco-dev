import 'package:arco_dev/src/pages/tutorial/third_tutorial.dart';
import 'package:arco_dev/src/utils/colors.dart';
import 'package:flutter/material.dart';

class SecondTutorialPage extends StatefulWidget {
  const SecondTutorialPage({super.key, required this.uid});
  final String uid;

  @override
  State<SecondTutorialPage> createState() => _SecondTutorialPageState();
}

class _SecondTutorialPageState extends State<SecondTutorialPage> {
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
                      'Google FitをHealth Connectと\n同期させてください',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
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
                    builder: (context) => ThirdTutorialPage(uid: widget.uid),
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
