import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../app_coloer.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';

class HBreadcrumbsWithHeading extends StatelessWidget {
  final List<String> breadcrumbsItems;
  final bool returnToPreviousScreen;
  const HBreadcrumbsWithHeading({
    super.key,
    required this.breadcrumbsItems,
    this.returnToPreviousScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40.w : 10.w,
        vertical: isDesktop ? 20.h : 15.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Breadcrumb items
          for (int i = 0; i < breadcrumbsItems.length; i++)
            Row(
              children: [
                // Breadcrumb text
                InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: i == breadcrumbsItems.length - 1
                      ? null
                      : () {
                          if (returnToPreviousScreen) {
                            Get.back();
                          } else {
                            Get.offNamed(breadcrumbsItems[i]);
                          }
                        },
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? HSizes.sm : HSizes.xs),
                    child: Text(
                      i == breadcrumbsItems.length - 1
                          ? breadcrumbsItems[i].capitalize.toString()
                          : capitalize(breadcrumbsItems[i].substring(1)),
                      style: TextStyle(
                        fontSize: isDesktop ? 20.sp : 24.sp,
                        color: i == breadcrumbsItems.length - 1
                            ? AppColor.primaryColor
                            : AppColor.primaryColor,
                        fontWeight: i == breadcrumbsItems.length - 1
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Separator (only show if not last item)
                if (i < breadcrumbsItems.length - 1)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isDesktop ? 8.w : 4.w),
                    child: Text(
                      ' < ',
                      style: TextStyle(
                        fontSize: isDesktop ? 24.sp : 32.sp,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

          // Home link
          if (breadcrumbsItems.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 8.w : 4.w),
              child: Text(
                ' < ',
                style: TextStyle(
                  fontSize: isDesktop ? 24.sp : 32.sp,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8.r),
              onTap: () => Get.offAllNamed(HRoutes.home),
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? HSizes.sm : HSizes.xs),
                child: Text(
                  "الرئيسية",
                  style: TextStyle(
                    fontSize: isDesktop ? 20.sp : 24.sp,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String capitalize(String s) =>
      s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);
}
