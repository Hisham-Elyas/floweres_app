import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../app_coloer.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';

class HBreadcrumbsWithHeading extends StatelessWidget {
  final List<String> breadcrumbsItems;
  final bool returnToPreviousScreen;
  const HBreadcrumbsWithHeading(
      {super.key,
      required this.breadcrumbsItems,
      this.returnToPreviousScreen = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (int i = 0; i < breadcrumbsItems.length; i++)
            Row(children: [
              InkWell(
                onTap: i == breadcrumbsItems.length - 1
                    ? null
                    : () => Get.offNamed(breadcrumbsItems[i]),
                child: Padding(
                  padding: EdgeInsets.all(HSizes.xs.dm),
                  child: Text(
                      i == breadcrumbsItems.length - 1
                          ? breadcrumbsItems[i].capitalize.toString()
                          : capitalize(breadcrumbsItems[i].substring(1)),
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ),
              Text(' < ',
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
          InkWell(
            onTap: () => Get.offAllNamed(HRoutes.home),
            child: Padding(
              padding: EdgeInsets.all(HSizes.xs.dm),
              child: Text("الرئيسية",
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          )
        ],
      ),
    );
  }
}

String capitalize(String s) =>
    s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);
