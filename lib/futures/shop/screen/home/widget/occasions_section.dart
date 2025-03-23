import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app_coloer.dart';
import '../../../../../routes/routes.dart';
import '../../../controller/occasion/occasion_controller.dart';
import '../../../controller/products/categories_products_details_controller.dart';

class OccasionsSection extends StatelessWidget {
  const OccasionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final occasionController = Get.put(OccasionController());

    return Column(children: [
      Padding(
        padding: EdgeInsets.all(16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("المناسبات",
                style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor)),
            SizedBox(height: 4.h),
            Container(
              width: 120.w, // Adjust width
              height: 3.h, // Thickness of the line
              color: AppColor.primaryColor, // Line color
            ),
          ],
        ),
      ),
      // Categories Grid

      Obx(() {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1.5),
          itemCount: occasionController.allItems.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                final ctegoriesProductsDetailsController =
                    Get.put(CategoriesProductsDetailsController());
                ctegoriesProductsDetailsController.getProductByCategories(
                  categoryId: occasionController.allItems[index].id,
                );
                Get.toNamed(HRoutes.categories,
                    arguments: occasionController.allItems[index].name);
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppColor.secondaryColor,
                    backgroundImage: NetworkImage(
                        occasionController.allItems[index].imageUrl),
                  ),
                  SizedBox(height: 8.h),
                  Text(occasionController.allItems[index].name,
                      style: TextStyle(
                          fontSize: 18.sp, color: AppColor.primaryColor)),
                ],
              ),
            );
          },
        );
      }),
    ]);
  }
}
