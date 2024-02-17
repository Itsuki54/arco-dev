// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './signup_page.dart';

void main() {
  runApp(const SignInPage());
}

const googleIcon = 'assets/images/google.svg';
Color backgroundColorGray = const Color(0xFF363636);
Color fillColorGray = const Color(0xFF656565);

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.black12,
          surface: Colors.white,
          background: Colors.white,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sign In'),
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = '';
  String password = '';
  bool visible = false;

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in failed. Please try again.'),
        ),
      );
      return null;
    }
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> signInWithEmailAndPassword() async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password.'),
        ),
      );
      return;
    }
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found.'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColorGray,
        body: ResponsiveLayout(
            child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(children: [
            Column(children: [
              SizedBox(height: 50),
              SizedBox(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          )))),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'and start your workout',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 24,
                    ),
                  )),
            ]),
            Column(
              children: [
                SizedBox(height: 80),
                SizedBox(
                    height: 50,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fillColorGray,
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail),
                      ),
                    )),
                SizedBox(height: 20),
                SizedBox(
                    height: 50,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fillColorGray,
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.key),
                        suffix: IconButton(
                          icon: Icon(
                            visible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              visible = !visible;
                            });
                          },
                        ),
                      ),
                    )),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text('Forgot password',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 20,
                        ))),
                SizedBox(height: 32),
                SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0))),
                        child: Text('Sign In',
                            style:
                                TextStyle(color: Colors.white, fontSize: 24)),
                        onPressed: () {
                          signInWithEmailAndPassword();
                        })),
                SizedBox(height: 32),
                Row(
                  children: const <Widget>[
                    Expanded(child: Divider(color: Colors.white)),
                    SizedBox(width: 40),
                    Text(
                      "OR",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    SizedBox(width: 40),
                    Expanded(child: Divider(color: Colors.white)),
                  ],
                ),
                SizedBox(height: 32),
                SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        icon: SvgPicture.asset(
                          'assets/images/google.svg',
                          width: 40,
                          height: 40,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0))),
                        label: Text('Continue with Google',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
                        onPressed: () {
                          signInWithGoogle().then((result) {
                            if (result != null) {
                              // ログイン後の処理
                            }
                          });
                        })),
                SizedBox(height: 32),
                SizedBox(
                    child: Row(children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Text('Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                  )
                ]))
              ],
            ),
          ]),
        )));
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget child;

  const ResponsiveLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
