import 'package:flutter/material.dart';
// components
import 'close_dialog_button.dart';
// structs
import '../structs/quest.dart';

class QuestDialog extends StatelessWidget {
  const QuestDialog({super.key, required this.quest});

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const CloseDialogButton(),
        Text(
          quest.name,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Image.asset(
          'assets/images/appicon.png',
          width: 150,
        ),
        const SizedBox(height: 24),
        Text(quest.description,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        SizedBox(
            width: 500,
            child: ElevatedButton(
                onPressed: quest.state == "受取り" ? () {} : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade800),
                child: const Text("ポイントを受け取る",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)))),
      ]),
    );
  }
}
