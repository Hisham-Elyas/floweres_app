import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class HChipTheme {
  HChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    checkmarkColor: HColors.white,
    selectedColor: HColors.primary,
    disabledColor: HColors.grey.withOpacity(0.4),
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    labelStyle: const TextStyle(color: HColors.black, fontFamily: 'Urbanist'),
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    checkmarkColor: HColors.white,
    selectedColor: HColors.primary,
    disabledColor: HColors.darkerGrey,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    labelStyle: TextStyle(color: HColors.white, fontFamily: 'Urbanist'),
  );
}
