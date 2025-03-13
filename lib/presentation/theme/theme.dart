import 'package:flutter/material.dart';
import 'package:new_parkingo/data/constants/colors.dart';
import 'package:new_parkingo/presentation/theme/widget%20themes/icon_theme.dart';
import 'package:new_parkingo/presentation/theme/widget%20themes/text_theme.dart';

class Parkingotheme {
  Parkingotheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.light,
    canvasColor: ParkingoColors.containerLight,
    textTheme: ParkingoTextTheme.textThemeLight,
    primaryColor: ParkingoColors.primary,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.dark,
    primaryColor: ParkingoColors.primary,
    textTheme: ParkingoTextTheme.textThemeDark,
    scaffoldBackgroundColor: ParkingoColors.scaffoldDark,
    canvasColor: ParkingoColors.containerDark,
    iconTheme: ParkningoIconTheme.iconThemeDark,
  );
}
