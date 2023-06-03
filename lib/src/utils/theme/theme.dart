import 'package:flutter/material.dart';
import 'package:noorbot_app/src/utils/theme/widget_themes/appbar_theme.dart';
import 'package:noorbot_app/src/utils/theme/widget_themes/bottom_navbar_theme.dart';
import 'package:noorbot_app/src/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:noorbot_app/src/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:noorbot_app/src/utils/theme/widget_themes/text_field_theme.dart';
import 'package:noorbot_app/src/utils/theme/widget_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TTextTheme.lightTextTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    bottomNavigationBarTheme: TBottomNavigationBarTheme.lightTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TTextTheme.darkTextTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    bottomNavigationBarTheme: TBottomNavigationBarTheme.darkTheme,
  );
}
