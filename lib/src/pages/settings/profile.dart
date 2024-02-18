import 'package:flutter/material.dart';

// components
import '../../components/common/child_appbar.dart';
// pages

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _image = File("assets/images/sample_icon.png");
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = File("default_image_path");
      }
    });
  }

  var isOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const ChildAppBar(title: "設定", icon: Icon(Icons.settings, size: 40)),
      body: Center(
        child: Column(
          children: [
            Stack(alignment: Alignment.center, children: [
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
                        fit: BoxFit.fill, image: FileImage(_image))),
              ),
            ]),
            ElevatedButton(
              onPressed: () {
                getImageFromGallery();
              },
              child: Text("画像を選択"),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("名前:", style: TextStyle(fontSize: 20)),
                Text("ID:", style: TextStyle(fontSize: 20)),
                Text("レベル:", style: TextStyle(fontSize: 20)),
                Text("メールアドレス:", style: TextStyle(fontSize: 20)),
                Switch(
                  value: isOn,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        isOn = value;
                        print("$isOn");
                      });
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
