import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class HAppBarTheme {
  HAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    iconTheme: IconThemeData(color: HColors.iconPrimary, size: HSizes.iconMd),
    actionsIconTheme:
        IconThemeData(color: HColors.iconPrimary, size: HSizes.iconMd),
    titleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: HColors.black,
        fontFamily: 'Urbanist'),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: HColors.dark,
    surfaceTintColor: HColors.dark,
    iconTheme: IconThemeData(color: HColors.black, size: HSizes.iconMd),
    actionsIconTheme: IconThemeData(color: HColors.white, size: HSizes.iconMd),
    titleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: HColors.white,
        fontFamily: 'Urbanist'),
  );
}
