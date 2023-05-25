import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:noorbot_app/src/constants/colors.dart';
import 'package:noorbot_app/src/constants/sizes.dart';
import 'package:noorbot_app/src/features/journaling/controllers/journals_controller.dart';

import '../journal_screen.dart';

class JournalCard extends StatelessWidget {
  const JournalCard({
    Key? key,
    // required this.text,
    required this.title,
    required this.createdAt,
  }) : super(key: key);

  final String title;
  final Timestamp createdAt;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(tJournalCardPadding),
          child: Row ( children: [Expanded(
              child: OutlinedButton(
                onPressed: () => {
                  Get.to(TextEditorScreen(createdAt: createdAt, editEnabled: false,))
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text('Feature Not Implemented'),
                  //     duration: Duration(seconds: 2),
                  //   ),
                  // )
                },
                  child: Column(children: [
                    Text(title,
                      style: const TextStyle(
                        // color: Colors.blue, // Text color
                        fontSize: 24, // Font size
                        // fontWeight: FontWeight.bold, // Font weight
                        fontStyle: FontStyle.normal, // Font style
                        letterSpacing: 2, // Spacing between letters
                        wordSpacing: 4, // Spacing between words
                      ),
                    ),
                    Text(DateFormat('yyyy-MM-dd')
                        .format(createdAt.toDate())
                        .toString(),
                    style: const TextStyle(
                      // color: Colors.blue, // Text color
                      fontSize: 12, // Font size
                      // fontWeight: FontWeight.bold, // Font weight
                      fontStyle: FontStyle.normal, // Font style
                      letterSpacing: 2, // Spacing between letters
                      wordSpacing: 4, // Spacing between words
                    ),
                  )]))),
      ]),
        ))
    ]);
  }
}
