import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

/* -- Light & Dark Outlined Button Themes -- */
class TBottomNavigationBarTheme {
  TBottomNavigationBarTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static const lightTheme = BottomNavigationBarThemeData(
    selectedItemColor: selectedItemColor,
    unselectedItemColor: tLightGreyColor,
    // side: const BorderSide(color: tSecondaryColor),
    // padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
  );

  /* -- Dark Theme -- */
  static const darkTheme = BottomNavigationBarThemeData(
    selectedItemColor: selectedItemColor,
    unselectedItemColor: tWhiteColor,
    // side: const BorderSide(color: tWhiteColor),
    // padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
  );
}
