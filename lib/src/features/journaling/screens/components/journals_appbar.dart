import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text_strings.dart';

class JournalsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const JournalsAppBar({
    Key? key,
    required this.isDark,
  }) : super(key: key);

  final bool isDark;

  displayHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(tJournalingHelpDialogTitle),
          content: const Text(tJournalingHelpDialogText),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Perform any action you need here
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Text(tJournalingAppbar,
          style: Theme.of(context).textTheme.headlineMedium),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20, top: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDark ? tSecondaryColor : tCardBgColor,
          ),
          child: IconButton(
            onPressed: () => {displayHelp(context)},
            icon: Icon(Icons.question_mark,
                color: isDark ? tWhiteColor : tDarkColor),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
