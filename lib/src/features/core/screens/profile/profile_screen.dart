import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:noorbot_app/src/constants/sizes.dart';
import 'package:noorbot_app/src/constants/text_strings.dart';
import 'package:noorbot_app/src/features/core/screens/bottom_navbar/bottom_navbar.dart';
import 'package:noorbot_app/src/features/core/screens/profile/update_profile_screen.dart';
import 'package:noorbot_app/src/features/core/screens/profile/widgets/image_with_icon.dart';
import 'package:noorbot_app/src/features/core/screens/profile/widgets/profile_menu.dart';
import 'package:noorbot_app/src/features/hotlines/hotlines_screen.dart';
import 'package:noorbot_app/src/features/phq_test/screens/phq_test.dart';

import '../../../../constants/colors.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../NotifcationsTime/notifications_time.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthenticationRepository.instance;

    // var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.to(const MyNavBar()),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title:
            Text(tProfile, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              /// -- IMAGE with ICON
              const ImageWithIcon(),
              const SizedBox(height: 5),
              Text(authRepo.getUserEmail,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => UpdateProfileScreen()),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(tEditProfile,
                      style: TextStyle(color: tDarkColor)),
                ),
              ),
              const SizedBox(height: 30),

              /// -- MENU
              ProfileMenuWidget(
                  title: "Notifications",
                  icon: LineAwesomeIcons.cog,
                  onPress: () => Get.to(const NotificationsTime())),
              ProfileMenuWidget(
                  title: "PHQ-9 Test",
                  icon: LineAwesomeIcons.wallet,
                  onPress: () => Get.to(const PHQTest())),
              ProfileMenuWidget(
                  title: tMenu4,
                  icon: LineAwesomeIcons.info,
                  onPress: () => Get.to(const HotLines())),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    Get.defaultDialog(
                      title: "LOGOUT",
                      titleStyle: const TextStyle(fontSize: 20),
                      content: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text("Are you sure, you want to Logout?"),
                      ),
                      confirm: Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              AuthenticationRepository.instance.logout(),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              side: BorderSide.none),
                          child: const Text("Yes"),
                        ),
                      ),
                      cancel: OutlinedButton(
                          onPressed: () => Get.back(), child: const Text("No")),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
