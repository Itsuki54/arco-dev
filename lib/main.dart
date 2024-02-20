import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
// pages
import 'package:arco_dev/src/pages/hub.dart';

import './firebase_options.dart';
import './src/utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: AppColors.indigo, // 主要な色
            secondary: Colors.black12, // セカンダリ色
            surface: Colors.white, // 表面色
            background: Colors.white, // 背景色
            error: Colors.red, // エラー色
            onPrimary: Colors.white, // 主要な色の上でのテキスト色
            onSecondary: AppColors.indigo,
            onSurface: AppColors.indigo,
            onBackground: AppColors.indigo,
            onError: Colors.red, // エラー色の上でのテキスト色
            brightness: Brightness.light, // 明るさ
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.notoSansJpTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: Hub());
    //home: HealthViewPage());
    //home: HealthApp());
  }
}
