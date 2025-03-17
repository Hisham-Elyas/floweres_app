import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../app_coloer.dart';
import '../../../controller/products/products_controller.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final productsController = Get.put(ProductsController());
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
            child: Row(children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "All Products For Test",
                        style: TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 50.h,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0),
                    side: const BorderSide(
                        color: AppColor.secondaryColor, width: 1),
                  ),
                  onPressed: () {},
                  child: Text("See All",
                      style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp)),
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 350.h,
            child: ListView.builder(
              itemCount: productsController.allItems.length,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final product = productsController.allItems[index];
                return Container(
                  width: 200.h,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Container(
                                    color:
                                        AppColor.primaryColor.withOpacity(0.1),
                                    child: CachedNetworkImage(
                                      imageUrl: product.imageUrl,
                                      fit: BoxFit.contain,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Center(
                                        child: Skeletonizer(
                                          enableSwitchAnimation: true,
                                          enabled: true,
                                          child: Skeleton.shade(
                                              child: Icon(Iconsax.image,
                                                  size: 60.dm)),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                              child: Icon(Icons.error)),
                                    )),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Column(
                                children: [
                                  Container(
                                      height: 40.dm,
                                      width: 40.dm,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 0.8,
                                              color: AppColor.primaryColor),
                                          color: Colors.white),
                                      child: Icon(
                                        Icons.favorite_border,
                                        size: 20.dm,
                                      )),
                                  SizedBox(height: 10.h),
                                  Container(
                                      height: 40.dm,
                                      width: 40.dm,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.8,
                                              color: AppColor.primaryColor),
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 20.dm,
                                      )),
                                ],
                              ),
                            ),
                            if (!product.isActive)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.3),
                                  child: Center(
                                    child: Transform.rotate(
                                      angle: -0.5,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 0.8,
                                            color: AppColor.emptyColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          "نفدت الكمية",
                                          style: TextStyle(
                                            color: AppColor.emptyColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(product.name,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      Text("SAR ${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.sp,
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            side: BorderSide(
                                color: product.isActive
                                    ? AppColor.primaryColor
                                    : Colors.grey,
                                width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          onPressed: product.isActive ? () {} : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.card_travel,
                                size: 22.dm,
                              ),
                              Text("إضافة للسلة",
                                  style: TextStyle(
                                      color: product.isActive
                                          ? AppColor.primaryColor
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
