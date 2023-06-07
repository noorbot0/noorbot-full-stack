import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/features/notifications/notifications_screen.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/image_strings.dart';
import '../../profile/profile_screen.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    Key? key,
    required this.isDark,
    required this.topTitle,
  }) : super(key: key);

  final bool isDark;
  final String topTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 10,
      centerTitle: true,
      backgroundColor: tmainGreenColor,
      automaticallyImplyLeading: false,
      // leading:
      // IconButton(
      //   onPressed: () => Get.to(() => const MyChat()),
      //   // onPressed: () => AuthenticationRepository.instance.logout(),
      //   icon: Icon(Icons.menu, color: isDark ? tWhiteColor : tDarkColor),
      // ),
      // color:tSecondaryColor,
      title: Text(topTitle, style: Theme.of(context).textTheme.headlineMedium),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
          // width: 40,
          // height: 40,
          // decoration: BoxDecoration(
          //   // borderRadius: BorderRadius.circular(10),
          //   color: tAppbarBGColor,
          //   shape: BoxShape.circle,
          // ),
          child: IconButton(
            onPressed: () => Get.to(() => const NotificationsScreen()),
            // onPressed: () => AuthenticationRepository.instance.logout(),
            icon: const Icon(
              Icons.notifications,
              color: tAppbarBGColor,
              shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 15.0)],
              size: 30,
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
