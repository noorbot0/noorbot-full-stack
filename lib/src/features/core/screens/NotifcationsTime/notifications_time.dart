import 'package:flutter/material.dart';
import '../../../../constants/sizes.dart';
import 'components/next_btn.dart';
import 'components/times_list.dart';

class NotificationsTime extends StatelessWidget {
  const NotificationsTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {    
       return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Choose a daily check-in time",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        const SizedBox(height: defaultPadding * 2),
        const TimesList(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: NextBtn(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}


