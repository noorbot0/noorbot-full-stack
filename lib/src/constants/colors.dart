import 'package:flutter/material.dart';

/* -- LIST OF ALL COLORS -- */
const tBGPrimaryColor = Color.fromARGB(255, 255, 255, 255);
const tPrimaryColor = Color(0xFFE5B74E);
const tSecondaryColor = Color(0xFF272727);
const tAccentColor = Color(0xFF001BFF);

const tWhiteColor = Colors.white;
const tDarkColor = Color(0xff000000);
const tCardBgColor = Color(0xFFF7F5F1);

const tbackgroundColor = [
  const Color(0xFFFFF7AD),
  const Color(0xFFABD1A7)
];

const tmainGreenColor =  const Color(0xFFABD1A7);
// -- ON-BOARDING COLORS
const tOnBoardingPage1Color = Colors.white;
const tOnBoardingPage2Color = Color(0xfffddcdf);
const tOnBoardingPage3Color = Color(0xffffdcbd);

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> sky = [const Color(0xFF439A97), const Color(0xFFCBEDD5)];
  static List<Color> sunset = [
    const Color(0xFFFE6197),
    const Color(0xFFFFB463)
  ];
  static List<Color> sea = [const Color(0xFF61A3FE), const Color(0xFF63FFD5)];
  static List<Color> mango = [const Color(0xFF2C3333), const Color(0xFFCBE4DE)];
  static List<Color> fire = [const Color(0xFFFF5DCD), const Color(0xFFFF8484)];
}


class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.mango),
    GradientColors(GradientColors.fire),
  ];
}

const kSecondaryColor = Color(0xFF8B94BC);
const kGreenColor = Color(0xFF6AC259);
const kRedColor = Color(0xFFE92E30);
const kGrayColor = Color(0xFFC1C1C1);
const kBlackColor = Color(0xFF101010);
const kPrimaryGradient = LinearGradient(
  colors: [
    Color.fromARGB(255, 177, 233, 242),
    Color.fromARGB(255, 181, 216, 209)
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const double kDefaultPadding = 20.0;

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);

  static const Color underLineOne = Color.fromARGB(255, 57, 243, 162);
  static const Color underLineTwo = Color.fromARGB(255, 207, 241, 111);
  static const Color backgroundOne = Color(0xFF625ed7);
  static const Color backgroundTwo = Color.fromARGB(255, 108, 105, 189);
  static const Color backgroundThree = Color.fromARGB(255, 201, 91, 231);
}
