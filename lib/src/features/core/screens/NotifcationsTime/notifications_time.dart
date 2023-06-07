import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:noorbot_app/src/constants/sizes.dart';
import 'package:noorbot_app/src/features/core/screens/NotifcationsTime/components/times_list.dart';
import 'package:noorbot_app/src/features/core/screens/bottom_navbar/bottom_navbar.dart';
import 'package:noorbot_app/src/features/core/screens/profile/profile_screen.dart';

import '../../../../constants/text_strings.dart';

class NotificationsTime extends StatelessWidget {
  const NotificationsTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Get.to(const ProfileScreen()),
                  icon: const Icon(LineAwesomeIcons.angle_left)),
              title: Text(tNotifications,
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            body: SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.all(tDashboardPadding),
                    child: Column(
                      children: [
                        Text(tNotificationTime, style: txtTheme.bodyMedium),
                        const TimesList(),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Get.to(() => const MyNavBar()),
                                // onPressed: () => Get.to(() => const Dashboard()),
                                child: Text(tSave.toUpperCase()),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )))));
  }
}
