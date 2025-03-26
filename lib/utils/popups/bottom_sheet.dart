import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HBottomSheet {
  static void openBottomSheet(
      {bool isDismissible = true,
      bool isScrollControlled = false,
      required Widget child}) {
    showModalBottomSheet(
      context: Get.context!,
      // backgroundColor: Colors.white,
      isScrollControlled: isScrollControlled,

      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return PopScope(canPop: isDismissible, child: child);
      },
    );
  }
}
