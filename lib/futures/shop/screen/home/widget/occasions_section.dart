import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app_coloer.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controller/occasion/occasion_controller.dart';
import '../../../controller/products/categories_products_details_controller.dart';

class OccasionsSection extends StatelessWidget {
  const OccasionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final occasionController = Get.put(OccasionController());
    final isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;
    final isTablet =
        MediaQuery.of(context).size.width >= HSizes.tabletScreenSize &&
            MediaQuery.of(context).size.width < HSizes.desktopScreenSize;

    return Column(
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: isDesktop ? 30.h : 16.h,
            horizontal: isDesktop ? 40.w : 16.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "المناسبات",
                style: TextStyle(
                  fontSize: isDesktop ? 42.sp : 36.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                ),
              ),
              SizedBox(height: isDesktop ? 8.h : 4.h),
              Container(
                width: isDesktop ? 160.w : 120.w,
                height: isDesktop ? 4.h : 3.h,
                color: AppColor.primaryColor,
              ),
            ],
          ),
        ),

        // Categories Grid
        Obx(() {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40.w : 16.w,
              vertical: isDesktop ? 20.h : 0,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 4 : (isTablet ? 3 : 2),
                childAspectRatio: isDesktop ? 1.2 : 1.5,
                mainAxisSpacing: isDesktop ? 30.h : 16.h,
                crossAxisSpacing: isDesktop ? 30.w : 16.w,
              ),
              itemCount: occasionController.allItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    final ctegoriesProductsDetailsController =
                        Get.put(CategoriesProductsDetailsController());
                    ctegoriesProductsDetailsController.getProductByCategories(
                      categoryId: occasionController.allItems[index].id,
                    );
                    Get.toNamed(
                      HRoutes.categories,
                      arguments: occasionController.allItems[index].name,
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: isDesktop ? 70.r : 50.r,
                        backgroundColor: AppColor.secondaryColor,
                        backgroundImage: NetworkImage(
                          occasionController.allItems[index].imageUrl,
                        ),
                      ),
                      SizedBox(height: isDesktop ? 12.h : 8.h),
                      Text(
                        occasionController.allItems[index].name,
                        style: TextStyle(
                          fontSize: isDesktop ? 22.sp : 18.sp,
                          color: AppColor.primaryColor,
                          fontWeight:
                              isDesktop ? FontWeight.w600 : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),

        // Add extra spacing for desktop
        if (isDesktop) SizedBox(height: 40.h),
      ],
    );
  }
}
