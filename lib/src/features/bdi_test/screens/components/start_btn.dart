import 'package:flutter/material.dart';
import 'package:noorbot_app/src/features/bdi_test/screens/components/test_screen.dart';

class StartBtn extends StatelessWidget {
  const StartBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const TestScreen();
                },
              ),
            );
          },
          child: const Text(
            "Start !",
          ),
        ),
      ],
    );
  }
}
