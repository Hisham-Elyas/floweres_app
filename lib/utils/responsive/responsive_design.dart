import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/sizes.dart';
import '../device/device_utility.dart';

class HResponsiveWidget extends StatelessWidget {
  final Widget desktop;
  final Widget tablet;
  final Widget mobile;
  const HResponsiveWidget(
      {super.key,
      required this.desktop,
      required this.tablet,
      required this.mobile});
  static double responsive(
      {required double desktop,
      required double tablet,
      required double mobile}) {
    if (HDeviceUtils.isDesktopScreen(Get.context!)) {
      return desktop;
    } else if (HDeviceUtils.isTabletScreen(Get.context!)) {
      return tablet;
    } else {
      return mobile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= HSizes.desktopScreenSize) {
          return desktop;
        } else if (constraints.maxWidth < HSizes.desktopScreenSize &&
            constraints.maxWidth >= HSizes.tabletScreenSize) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
