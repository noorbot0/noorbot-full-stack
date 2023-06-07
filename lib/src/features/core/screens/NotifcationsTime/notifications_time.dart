import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:noorbot_app/src/features/core/screens/dashboard/dashboard.dart';
import 'package:noorbot_app/src/features/core/screens/profile/profile_screen.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../dashboard/widgets/appbar.dart';
import 'components/times_list.dart';

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
                  onPressed: () => Get.to(ProfileScreen()),
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
                                onPressed: () => Get.snackbar(
                                    "Updated", "You will receive notifications at this time"),
                                child: Text(tSave.toUpperCase()),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )))));
  }
}
