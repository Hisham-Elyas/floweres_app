import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class HTextFormFieldTheme {
  HTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: HColors.darkGrey,
    suffixIconColor: HColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: HSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
        fontSize: HSizes.fontSizeMd,
        color: HColors.textPrimary,
        fontFamily: 'Urbanist'),
    hintStyle: const TextStyle().copyWith(
        fontSize: HSizes.fontSizeSm,
        color: HColors.textSecondary,
        fontFamily: 'Urbanist'),
    errorStyle: const TextStyle()
        .copyWith(fontStyle: FontStyle.normal, fontFamily: 'Urbanist'),
    floatingLabelStyle: const TextStyle()
        .copyWith(color: HColors.textSecondary, fontFamily: 'Urbanist'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(HSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: HColors.borderPrimary),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(HSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: HColors.borderPrimary),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(HSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: HColors.borderSecondary),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(HSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: HColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(HSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: HColors.error),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: HColors.darkGrey,
    suffixIconColor: HColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: HSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
        fontSize: HSizes.fontSizeMd,
        color: HColors.white,
        fontFamily: 'Urbanist'),
    hintStyle: const TextStyle().copyWith(
        fontSize: HSizes.fontSizeSm,
        color: HColors.white,
        fontFamily: 'Urbanist'),
    floatingLabelStyle: const TextStyle().copyWith(
        color: HColors.white.withOpacity(0.8), fontFamily: 'Urbanist'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(HSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: HColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(HSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: HColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(HSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: HColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(HSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: HColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(HSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: HColors.error),
    ),
  );
}
