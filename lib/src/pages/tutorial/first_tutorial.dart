import 'package:arco_dev/src/pages/tutorial/second_tutorial.dart';
import 'package:arco_dev/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FirstTutorialPage extends StatefulWidget {
  const FirstTutorialPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<FirstTutorialPage> createState() => _FirstTutorialPageState();
}

class _FirstTutorialPageState extends State<FirstTutorialPage> {
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
                    SizedBox(child: ToHealthConnect()),
                    SizedBox(height: 18),
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
                    SizedBox(child: ToGoogleFit()),
                    SizedBox(height: 18),
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
            MaterialPageRoute(
                builder: (context) => SecondTutorialPage(uid: widget.uid)),
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

class ToHealthConnect extends StatelessWidget {
  ToHealthConnect({Key? key}) : super(key: key);

  final _urlLaunchWithStringButton = UrlLaunchWithStringButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: ElevatedButton(
        clipBehavior: Clip.antiAlias,
        onPressed: () => {
          _urlLaunchWithStringButton.launchUriWithString(
            context,
            "https://play.google.com/store/apps/details?id=com.google.android.apps.healthdata",
          )
        },
        child: Image.asset(
          'assets/images/HealthConnect.webp',
          fit: BoxFit.cover,
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class ToGoogleFit extends StatelessWidget {
  ToGoogleFit({Key? key}) : super(key: key);

  final _urlLaunchWithStringButton = UrlLaunchWithStringButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: ElevatedButton(
        clipBehavior: Clip.antiAlias,
        onPressed: () => {
          _urlLaunchWithStringButton.launchUriWithString(
            context,
            "https://play.google.com/store/apps/details?id=com.google.android.apps.fitness",
          )
        },
        child: Image.asset(
          'assets/images/GoogleFit.webp',
          fit: BoxFit.cover,
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Adjust the value as needed
          ),
          padding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}

class UrlLaunchWithStringButton {
  final alertSnackBar = SnackBar(
    content: const Text('このURLは開けませんでした'),
    action: SnackBarAction(
      label: '戻る',
      onPressed: () {},
    ),
  );

  Future launchUriWithString(BuildContext context, String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      alertSnackBar;
      ScaffoldMessenger.of(context).showSnackBar(alertSnackBar);
    }
  }
}
