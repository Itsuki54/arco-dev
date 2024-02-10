import 'package:flutter/material.dart';

void main() {
  runApp(const FirstPage());
}

Color backgroundColorGray = const Color(0xFF363636);

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: const MyHomePage(title: 'Welcome'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColorGray,
        appBar: AppBar(
          backgroundColor: backgroundColorGray,
          title: Text(widget.title),
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
            //画面遷移実装
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
