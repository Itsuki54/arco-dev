// import 'package:flutter/material.dart';
// // components
// import '../../components/button/close_dialog_button.dart';
// // structs
// import '../../structs/quest.dart';
// import 'package:arco_dev/src/utils/database.dart';

// class AchievementDialog extends StatelessWidget {
//   AchievementDialog({
//     super.key,
//     required this.quest,
//     required this.uid,
//     required this.onChanged,
//   });

//   // parameters
//   final Quest quest;
//   final String uid;
//   final VoidCallback onChanged;

//   // database
//   Database db = Database();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       content: Column(mainAxisSize: MainAxisSize.min, children: [
//         const CloseDialogButton(),
//         Text(
//           quest.name,
//           style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 24),
//         Image.asset(
//           'assets/images/appicon.png',
//           width: 150,
//         ),
//         const SizedBox(height: 24),
//         Text(quest.description,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 24),
//         SizedBox(
//             width: 500,
//             child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.yellow.shade800),
//                 child: Text("閉じる",
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold)))),
//       ]),
//     );
//   }
// }
