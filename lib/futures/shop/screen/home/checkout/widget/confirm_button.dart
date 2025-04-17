import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../app_coloer.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool? isDesktop; // Make optional to auto-detect
  final double? width; // Make width customizable
  final double? height; // Make height customizable
  final EdgeInsetsGeometry? padding; // Custom padding
  final double? elevation; // Custom elevation
  final double? fontSize; // Custom font size

  const ConfirmButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isDesktop,
    this.width,
    this.height,
    this.padding,
    this.elevation,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    // Auto-detect device type if not specified
    final isLargeScreen = isDesktop ?? HDeviceUtils.isDesktopScreen(context);
    final isTablet = HDeviceUtils.isTabletScreen(context);

    return SizedBox(
      width: width ?? double.infinity, // Use provided width or full width
      height: height ??
          (isLargeScreen
              ? 60.h
              : isTablet
                  ? 55.h
                  : 50.h),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          padding: padding ??
              EdgeInsets.symmetric(
                vertical: isLargeScreen ? 18.h : 14.h,
                horizontal: isLargeScreen ? 32.w : 24.w,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              isLargeScreen ? HSizes.borderRadiusLg : HSizes.borderRadiusMd,
            ),
          ),
          elevation: elevation ?? (isLargeScreen ? 4 : 2),
          shadowColor: AppColor.primaryColor.withOpacity(0.3),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize ?? (isLargeScreen ? 18.sp : 16.sp),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
