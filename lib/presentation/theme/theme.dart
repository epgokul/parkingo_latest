import 'package:flutter/material.dart';
import 'package:new_parkingo/data/constants/colors.dart';
import 'package:new_parkingo/presentation/theme/widget%20themes/text_field_theme.dart';

class Parkingotheme {
  Parkingotheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.light,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ParkingoColors.scaffoldDark,
    inputDecorationTheme: TextFieldTheme.textfieldDarkTheme,
  );
}
