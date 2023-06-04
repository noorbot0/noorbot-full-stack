import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
          // top: Radius.circular(20),
        ),
      ),
      elevation: 10,
      centerTitle: true,
      backgroundColor: tAppbarBGColor,
      automaticallyImplyLeading: false,
      // leading:
      // IconButton(
      //   onPressed: () => Get.to(() => const MyChat()),
      //   // onPressed: () => AuthenticationRepository.instance.logout(),
      //   icon: Icon(Icons.menu, color: isDark ? tWhiteColor : tDarkColor),
      // ),
      title: Text(topTitle, style: Theme.of(context).textTheme.headlineMedium),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
          // width: 40,
          // height: 40,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            color: isDark ? tSecondaryColor : tAppbarProbileBGColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => Get.to(() => const ProfileScreen()),
            // onPressed: () => AuthenticationRepository.instance.logout(),
            icon: const Image(image: AssetImage(tUserProfileImage)),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(55);
}
