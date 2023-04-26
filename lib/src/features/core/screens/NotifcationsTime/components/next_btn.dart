import 'package:flutter/material.dart';
import 'package:noorbot_app/src/features/core/screens/dashboard/dashboard.dart';

class NextBtn extends StatelessWidget {
  const NextBtn({
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
                  return const Dashboard();
                },
              ),
            );
          },
          child: const Text(
            "Next !",
          ),
        ),
      ],
    );
  }
}
