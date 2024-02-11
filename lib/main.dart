import 'package:flutter/material.dart';
// pages
import './src/pages/backpack/backpack.dart';

// for test
import './src/pages/settings/settings.dart';

void main() {
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
        colorScheme: const ColorScheme.light(
          primary: Colors.black, // 主要な色
          secondary: Colors.black12, // セカンダリ色
          surface: Colors.white, // 表面色
          background: Colors.white, // 背景色
          error: Colors.red, // エラー色
          onPrimary: Colors.white, // 主要な色の上でのテキスト色
          onSecondary: Colors.black, // セカンダリ色の上でのテキスト色
          onSurface: Colors.black, // 表面色の上でのテキスト色
          onBackground: Colors.black, // 背景色の上でのテキスト色
          onError: Colors.white, // エラー色の上でのテキスト色
          brightness: Brightness.light, // 明るさ
        ),
        useMaterial3: true,
      ),
      home: SettingsPage(),
      //home: BackpackPage(),
    );
  }
}
