import 'package:flutter/material.dart';

class AuthenticateDialog extends StatelessWidget {
  const AuthenticateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("認証", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      ]),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text("認証メールをお送りしました",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const SizedBox(
                width: 100,
                height: 42,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("閉じる",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                  ],
                ))),
      ]),
    );
  }
}
