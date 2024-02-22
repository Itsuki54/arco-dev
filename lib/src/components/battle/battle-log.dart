import 'package:flutter/material.dart';

class BattleLog extends StatelessWidget {
  const BattleLog({Key? key, required this.log}) : super(key: key);
  final List<String> log;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Battle Log'),
      content: Container(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          itemCount: log.length,
          itemBuilder: (context, index) {
            return Text(log[index]);
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
