// ignore_for_file: prefer_const_constructors

import 'package:arco_dev/src/pages/hub.dart';
import 'package:arco_dev/src/utils/colors.dart';
import 'package:arco_dev/src/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './signin_page.dart';

const googleIcon = 'assets/images/google.svg';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final Database db = Database();
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool visible = false;
  bool visible2 = false;

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

  Future<void> afterSignUp() async {
    await db.usersCollection().createUser(_auth.currentUser!.uid, {
      'email': email,
      'createdAt': DateTime.now(),
      'level': 1,
      'name': 'New User',
      'exp': 0.0,
      'userId': _auth.currentUser!.uid,
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Hub(uid: _auth.currentUser!.uid)),
    );
  }

  Future<void> signUpWithEmailAndPassword() async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
      return;
    }
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      afterSignUp();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The account already exists.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while signing up.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.indigo,
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(children: [
            Column(children: [
              SizedBox(height: 50),
              SizedBox(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('登録',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          )))),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'して運動を始めましょう',
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
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.lightIndigo,
                        labelText: 'メールアドレス',
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
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.lightIndigo,
                        labelText: 'パスワード',
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
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value != password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.lightIndigo,
                        labelText: 'パスワードを再入力',
                        prefixIcon: Icon(Icons.key),
                        suffix: IconButton(
                          icon: Icon(
                            visible2 ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              visible2 = !visible2;
                            });
                          },
                        ),
                      ),
                    )),
                SizedBox(height: 32),
                SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0))),
                        child: Text('登録',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: () {
                          signUpWithEmailAndPassword();
                        })),
                SizedBox(height: 32),
                Row(
                  children: const <Widget>[
                    Expanded(child: Divider(color: Colors.white)),
                    SizedBox(width: 40),
                    Text(
                      "OR",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(width: 40),
                    Expanded(child: Divider(color: Colors.white)),
                  ],
                ),
                SizedBox(height: 32),
                SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        icon: SvgPicture.asset(
                          'assets/images/google.svg',
                          width: 32,
                          height: 32,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0))),
                        label: Text('Googleでログイン',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                        onPressed: () {
                          signInWithGoogle().then((result) {
                            if (result != null) {
                              afterSignUp();
                            }
                          });
                        })),
                SizedBox(height: 32),
                SizedBox(
                    child: Row(children: [
                  Text(
                    'アカウントを持っていますか?',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Text('サインイン',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
