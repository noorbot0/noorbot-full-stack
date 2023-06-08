import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/features/core/screens/bottom_navbar/bottom_navbar.dart';
import 'package:noorbot_app/src/features/phq_test/screens/phq_test.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String description;

  CustomDialog({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        description,

        maxLines: null, // Allow wrapping
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Restart'),
          onPressed: () {
            Get.to(PHQTest());
          },
        ),
        TextButton(
          child: Text('Home'),
          onPressed: () {
            // Perform some action
            Get.to(MyNavBar());
          },
        ),
      ],
    );
  }
}
