import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app_coloer.dart';
import '../../../../data/abstract/base_data_controller.dart';
import '../../../../data/repositories/products/products_repo.dart';
import '../../../../utils/popups/bottom_sheet.dart';
import '../../model/products_model.dart';
import '../cart/cart_controller.dart';

class ProductsController extends HBaseDataController<ProductsModel> {
  static ProductsController get instance => Get.find();
  final _productsRepo = Get.put(ProductsRepo());

  @override
  Stream<List<ProductsModel>> streamItems() {
    return _productsRepo.getAllProductsStream();
  }

  @override
  bool containsSearchQuery(ProductsModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  void showProductDestils({required ProductsModel product}) {
    HBottomSheet.openBottomSheet(
      child: BottomSheetProdutsWidget(product: product),
      isScrollControlled: true,
    );
  }
}

class BottomSheetProdutsWidget extends StatelessWidget {
  final ProductsModel product;
  const BottomSheetProdutsWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // width: 200.h,
        //  padding:  EdgeInsets.only(
        //   bottom:
        //       MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        // ),

        decoration: BoxDecoration(
            // color: AppColor.,
            borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // height: 400.h,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                      color: AppColor.primaryColor.withOpacity(0.1),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.contain,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: Skeletonizer(
                            enableSwitchAnimation: true,
                            enabled: true,
                            child: Skeleton.shade(
                                child: Icon(Iconsax.image, size: 60.dm)),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error)),
                      )),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.heart,
                    size: 28.dm,
                    color: AppColor.primaryColor,
                  ),
                  SizedBox(height: 15.h),
                  Text(product.name,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 5.h),
                  Text("SAR ${product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 18.sp,
                      )),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Icon(
                        product.isActive
                            ? Iconsax.verify
                            : Iconsax.close_circle,
                        size: 24.dm,
                        color: product.isActive
                            ? AppColor.greinColor
                            : AppColor.emptyColor,
                      ),
                      SizedBox(width: 5.h),
                      Text(product.isActive ? "	متوفر	" : "نفدت الكمية",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: product.isActive
                                ? AppColor.greinColor
                                : AppColor.emptyColor,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Text(product.detail,
                      style: TextStyle(
                        fontSize: 16.sp,
                        // color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 15.h),
                  Text("تاريخ التوصيل",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w900,
                      )),
                  SizedBox(height: 55.h),
                  Text("عبارة الاهداء ",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w900,
                      )),
                  Text("اكتب العبارة اللي حاب نطبعها لك بالكرت",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 100.h,
                    child: const TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                  strokeAlign: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                  strokeAlign: 1)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.secondaryColor,
                                  strokeAlign: 1))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              side: BorderSide(
                  color: product.isActive ? AppColor.primaryColor : Colors.grey,
                  width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: product.isActive
                ? () {
                    CartController.instance.addItemToCart(product: product);
                  }
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  product.isActive ? Icons.card_travel : Iconsax.close_circle,
                  size: 22.dm,
                  color: product.isActive
                      ? AppColor.primaryColor
                      : AppColor.emptyColor,
                ),
                SizedBox(width: 15.h),
                Text(product.isActive ? "إضافة للسلة" : "نفدت الكمية",
                    style: TextStyle(
                        color: product.isActive
                            ? AppColor.primaryColor
                            : AppColor.emptyColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp))
              ],
            )),
      ),
    );
  }
}
