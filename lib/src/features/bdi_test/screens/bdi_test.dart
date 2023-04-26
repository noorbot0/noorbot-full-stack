import 'package:flutter/material.dart';
import '../../../constants/sizes.dart';
import 'components/start_btn.dart';

class BdiTest extends StatelessWidget {
  const BdiTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: defaultPadding * 6),
        const Text(
          "Spot your feelings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        const SizedBox(height: defaultPadding * 2),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: StartBtn(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
