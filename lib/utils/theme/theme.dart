import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../theme/widget_themes/appbar_theme.dart';
import '../theme/widget_themes/bottom_sheet_theme.dart';
import '../theme/widget_themes/checkbox_theme.dart';
import '../theme/widget_themes/chip_theme.dart';
import '../theme/widget_themes/elevated_button_theme.dart';
import '../theme/widget_themes/outlined_button_theme.dart';
import '../theme/widget_themes/text_field_theme.dart';
import '../theme/widget_themes/text_theme.dart';

class HAppTheme {
  HAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    disabledColor: HColors.grey,
    brightness: Brightness.light,
    primaryColor: HColors.primary,
    textTheme: HTextTheme.lightTextTheme,
    chipTheme: HChipTheme.lightChipTheme,
    appBarTheme: HAppBarTheme.lightAppBarTheme,
    checkboxTheme: HCheckboxTheme.lightCheckboxTheme,
    scaffoldBackgroundColor: HColors.primaryBackground,
    bottomSheetTheme: HBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: HElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: HOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: HTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    disabledColor: HColors.grey,
    brightness: Brightness.dark,
    primaryColor: HColors.primary,
    textTheme: HTextTheme.darkTextTheme,
    chipTheme: HChipTheme.darkChipTheme,
    appBarTheme: HAppBarTheme.darkAppBarTheme,
    checkboxTheme: HCheckboxTheme.darkCheckboxTheme,
    scaffoldBackgroundColor: HColors.primary.withOpacity(0.1),
    bottomSheetTheme: HBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: HElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: HOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: HTextFormFieldTheme.darkInputDecorationTheme,
  );
}
