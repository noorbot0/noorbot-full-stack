import 'package:flutter/material.dart';

/* -- LIST OF ALL COLORS -- */
const tBGPrimaryColor = Color.fromARGB(255, 255, 255, 255);
const tPrimaryColor = Color(0xFFABD1A7);
const tDarkPrimaryColor = Color.fromARGB(255, 84, 190, 73);
const tSecondaryColor = Color(0xFF272727);
const tLightGreyColor = Color.fromARGB(255, 122, 122, 122);
const tAccentColor = Color(0xFF001BFF);

const tWhiteColor = Colors.white;
const tDarkColor = Color(0xff000000);
const tCardBgColor = Color(0xFFF7F5F1);

const tbackgroundColor = [Color(0xFFFFF7AD), Color(0xFFABD1A7)];
const tbackgroundColorFlipped = [
  Color.fromARGB(255, 159, 206, 154),
  Color.fromARGB(255, 248, 237, 139)
];

const tmainGreenColor = Color(0xFFABD1A7);
// -- ON-BOARDING COLORS
const tOnBoardingPage1Color = Colors.white;
const tOnBoardingPage2Color = Color(0xfffddcdf);
const tOnBoardingPage3Color = Color(0xffffdcbd);

/* -- Navbar colors -- */
const selectedItemColor = Color.fromARGB(255, 84, 190, 73);
const nbShadowColor = Color.fromARGB(45, 0, 0, 0);

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

// Net Sentiment Score Chart Colors
const Color mainGridLineColor = Colors.white10;
const Color underLineOne = Color.fromARGB(255, 57, 243, 162);
const Color underLineTwo = Color.fromARGB(255, 207, 241, 111);
const Color backgroundOne = Color(0xFF625ed7);
const Color backgroundTwo = Color.fromARGB(255, 108, 105, 189);
const Color backgroundThree = Color.fromARGB(255, 201, 91, 231);

// Overall Chart Colors
const Color oaPosSectorColor = Color(0xFF5b9e2e);
const Color oaNeuSectorColor = Color(0xFFefee5b);
const Color oaNegSectorColor = Color(0xFFd44848);
const Color oaBackgroundOne = Color.fromARGB(255, 148, 227, 219);
const Color oaBackgroundTwo = Color.fromARGB(255, 86, 211, 200);
// const Color oaBackgroundOne = Color(0xFFe87e7c);
// const Color oaBackgroundTwo = Color(0xFFfeb4b4);

// Rank Chart Colors
const Color rankBackgroundOne = Color.fromARGB(255, 148, 227, 219);
const Color rankBackgroundTwo = Color.fromARGB(255, 86, 211, 200);
// const Color rankBackgroundOne = Color(0xFF7CE8CF);
// const Color rankBackgroundTwo = Color.fromARGB(255, 180, 254, 233);
const Color rankRanksColor = Color(0xFFE192E8);

// Daily Chart Colors
const Color dailyBackgroundOne = Color.fromARGB(255, 148, 227, 219);
const Color dailyBackgroundTwo = Color.fromARGB(255, 86, 211, 200);
const Color dailyGridColor = Color.fromARGB(255, 80, 174, 166);
const Color dailyRanksColor = Color(0xFFE192E8);

// Tracking card colors
const titleColor = Color.fromARGB(255, 106, 159, 94);
const cardBGColor = Color.fromARGB(255, 255, 255, 255);
const cardShadowColor = Color.fromARGB(255, 225, 225, 225);

// App Colors
const Color tAppbarBGColor = Color(0xFFF0E37F);
const Color tAppbarProbileBGColor = Color.fromARGB(255, 125, 158, 218);

const kBackgroundColor = Color(0xFFF8F8F8);
const kActiveIconColor = Color(0xFFE68342);
const kTextColor = Color(0xFF222B45);
const kBlueLightColor = Color(0xFFC7B8F5);
const kBlueColor = Color(0xFF817DC0);
const kShadowColor = Color(0xFFE6E6E6);
