import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/features/core/screens/dashboard/dashboard.dart';
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
            appBar: DashboardAppBar(
              isDark: isDark,
            ),
            body: SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.all(tDashboardPadding),
                    child: Column(
                      children: [
                        Text(tNotificationTime, style: txtTheme.bodyMedium),
                        // const SizedBox(height: defaultPadding * 2),
                        const TimesList(),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    Get.to(() => const Dashboard()),
                                child: Text(tNext.toUpperCase()),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )))));
  }
}
