import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// components
import '../../components/common/child_appbar.dart';
import 'package:arco_dev/src/components/settings/authenticate_dialog.dart';
import 'package:arco_dev/src/components/settings/change_name_dialog.dart';
// pages
import 'dart:io';
import 'package:image_picker/image_picker.dart';
// utils
import 'package:arco_dev/src/utils/database.dart';
import 'package:arco_dev/src/utils/storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _image = File("assets/images/sample_icon.png");
  final picker = ImagePicker();

  // firebase
  Database db = Database();
  Storage st = Storage();
  final FirebaseAuth auth = FirebaseAuth.instance;

  // user info
  String userName = "";
  String email = "";

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        st.users().upload(_image.path, userName);
      } else {
        _image = File("assets/images/sample_icon.png");
      }
    });
  }

  // 入力データをもとに、firebaseを更新する
  Future<void> setUserProfile() async {
    setState(() {
      // ユーザ名と名前の変更
      if (userName != "") {
        db.usersCollection().update(widget.uid, {"name": userName});
        showDialog<void>(
            context: context,
            builder: (_) {
              return const ChangeNameDialog();
            });
      }
      if (email != "") {
        db.usersCollection().update(widget.uid, {"email": email});
        auth.currentUser!.verifyBeforeUpdateEmail(email);
        showDialog<void>(
            context: context,
            builder: (_) {
              return const AuthenticateDialog();
            });
      }
    });
  }

  var levelPub = false;

  @override
  void initState() {
    super.initState();
    db.usersCollection().findById(widget.uid).then((value) {
      setState(() {
        userName = value["name"];
        email = value["email"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const ChildAppBar(
            title: "設定", icon: Icon(Icons.settings, size: 40)),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          const SizedBox(height: 32),
          Stack(alignment: Alignment.center, children: [
            Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
                child: const Icon(
                  Icons.person,
                  size: 150,
                  color: Colors.black45,
                )),
            Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: FileImage(_image),
                    )))
          ]),
          const SizedBox(height: 32),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                getImageFromGallery();
              },
              child: const SizedBox(
                  height: 52,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "画像を選択",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ]))),
          const SizedBox(height: 20),
          Column(children: [
            Row(children: [
              const SizedBox(width: 30),
              Expanded(
                  child: SizedBox(
                      height: 50,
                      child: TextField(
                          onChanged: (value) {
                            setState(() {
                              userName = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: '名前',
                          )))),
              const SizedBox(width: 30),
            ])
          ]),
          const SizedBox(height: 20),
          Column(children: [
            Row(children: [
              const SizedBox(width: 30),
              Expanded(
                  child: SizedBox(
                      height: 50,
                      child: TextField(
                          onChanged: (value) {
                            setState(() {
                              email = value;
                              db
                                  .usersCollection()
                                  .update(widget.uid, {"email": email});
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'メールアドレス',
                          )))),
              const SizedBox(width: 30)
            ])
          ]),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(width: 30),
            const Text("スコアの公開", style: TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Switch(
                value: levelPub,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      levelPub = value;
                    });
                  }
                })
          ]),
          const SizedBox(height: 120),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, elevation: 3),
              onPressed: () {
                setUserProfile();
              },
              child: const SizedBox(
                  height: 52,
                  width: 200,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "保存",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ])))
        ]))));
  }
}
