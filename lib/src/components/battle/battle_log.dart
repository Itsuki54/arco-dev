import 'package:flutter/material.dart';

class BattleLog extends StatelessWidget {
  const BattleLog(
      {Key? key,
      required this.log,
      required this.expLog,
      required this.party,
      required this.win})
      : super(key: key);
  final List<String> log;
  final List<String> expLog;
  final List<String> party;
  final bool win;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('バトル結果'),
      content: Container(
          width: double.maxFinite,
          height: 240,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${win ? '勝利' : '敗北'}',
                    style: TextStyle(
                        color: win ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                const SizedBox(height: 10),
                for (int i = 0; i < expLog.length; i++)
                  Text('${party[i]}は${expLog[i]}経験値を獲得した'),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: log.length,
                    itemBuilder: (context, index) {
                      return Text(log[index]);
                    },
                  ),
                ),
              ])),
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
