// packages
import 'package:flutter/material.dart';
// components
import './quest_dialog.dart';
import './quest_state_chip.dart';
// structs
import '../structs/quest.dart';

class QuestContent extends StatefulWidget {
  const QuestContent({
    super.key,
    required this.quest,
  });

  final Quest quest;

  @override
  State<QuestContent> createState() => _QuestContent();
}

class _QuestContent extends State<QuestContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 70,
      margin: const EdgeInsets.all(6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Colors.white,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  QuestDialog(quest: widget.quest));
        },
        child: Container(
            padding: const EdgeInsets.all(2),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.quest.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      "${widget.quest.point} point",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const Expanded(child: SizedBox()),
                //DoneButton(),
                QuestStateChip(state: widget.quest.state),
              ],
            )),
      ),
    );
  }
}
