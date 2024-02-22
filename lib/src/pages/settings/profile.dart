import 'package:flutter/material.dart';

// components
import '../../components/common/child_appbar.dart';
// pages
import 'dart:io';
import 'package:image_picker/image_picker.dart';
// utils
import 'package:arco_dev/src/utils/database.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _image = File("assets/images/sample_icon.png");
  final picker = ImagePicker();

  Database db = Database();

  // user info
  String userName = "guest";
  String email = "guest@guest";

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = File("assets/images/sample_icon.png");
      }
    });
  }

  var levelPub = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const ChildAppBar(title: "設定", icon: Icon(Icons.settings, size: 40)),
      body: Center(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                ),
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: FileImage(_image),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                getImageFromGallery();
              },
              child: const Text("画像を選択",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  children: [
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
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        db
                            .usersCollection()
                            .update(widget.uid, {"name": userName});
                      },
                      child: const Text("保存",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  children: [
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
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("保存",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 30),
                const Text("レベルの公開設定", style: TextStyle(fontSize: 20)),
                Switch(
                  value: levelPub,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(
                        () {
                          levelPub = value;
                          print("$levelPub");
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
