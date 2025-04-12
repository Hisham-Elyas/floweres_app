import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app_coloer.dart';
import '../../../../data/abstract/base_data_controller.dart';
import '../../../../data/repositories/products/products_repo.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/popups/bottom_sheet.dart';
import '../../model/products_model.dart';
import '../cart/cart_controller.dart';
import 'favorites_controller.dart';

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
    final isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40.w : 35.w,
            vertical: isDesktop ? 30.h : 20.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(isDesktop ? 20.r : 15.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: isDesktop ? 350.h : 250.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isDesktop ? 15.r : 10.r),
                  color: AppColor.primaryColor.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isDesktop ? 15.r : 10.r),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.contain,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: Skeletonizer(
                        enableSwitchAnimation: true,
                        enabled: true,
                        child: Skeleton.shade(
                          child: Icon(
                            Iconsax.image,
                            size: isDesktop ? 80.dm : 60.dm,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(
                        Icons.error,
                        size: isDesktop ? 80.dm : 60.dm,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isDesktop ? 30.h : 15.h),

              // Product Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Favorite Button
                  Obx(() {
                    final favoritesController = Get.put(FavoritesController());
                    return IconButton(
                      iconSize: isDesktop ? 40.dm : 32.dm,
                      onPressed: () =>
                          favoritesController.toggleFavorite(product),
                      icon: Icon(
                        favoritesController.isFavorite(product)
                            ? Iconsax.heart5
                            : Iconsax.heart,
                        color: AppColor.primaryColor,
                      ),
                    );
                  }),

                  // Product Name and Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: isDesktop ? 28.sp : 24.sp,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "SAR ${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: isDesktop ? 22.sp : 18.sp,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isDesktop ? 20.h : 15.h),

              // Availability
              Row(
                children: [
                  Icon(
                    product.isActive ? Iconsax.verify : Iconsax.close_circle,
                    size: isDesktop ? 28.dm : 24.dm,
                    color: product.isActive
                        ? AppColor.greinColor
                        : AppColor.emptyColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    product.isActive ? "متوفر" : "نفدت الكمية",
                    style: TextStyle(
                      fontSize: isDesktop ? 18.sp : 14.sp,
                      color: product.isActive
                          ? AppColor.greinColor
                          : AppColor.emptyColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isDesktop ? 30.h : 15.h),

              // Product Details
              Text(
                "التفاصيل",
                style: TextStyle(
                  fontSize: isDesktop ? 24.sp : 20.sp,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                product.detail,
                style: TextStyle(
                  fontSize: isDesktop ? 18.sp : 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isDesktop ? 30.h : 15.h),

              // Delivery Date
              Text(
                "تاريخ التوصيل",
                style: TextStyle(
                  fontSize: isDesktop ? 24.sp : 20.sp,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: isDesktop ? 30.h : 15.h),

              // Gift Message
              Text(
                "عبارة الاهداء",
                style: TextStyle(
                  fontSize: isDesktop ? 24.sp : 20.sp,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "اكتب العبارة اللي حاب نطبعها لك بالكرت",
                style: TextStyle(
                  fontSize: isDesktop ? 18.sp : 16.sp,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: isDesktop ? 150.h : 100.h,
                child: TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColor.primaryColor,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColor.primaryColor,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColor.primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isDesktop ? 40.h : 20.h),
            ],
          ),
        ),
      ),

      // Add to Cart Button
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 40.w : 15.w,
          vertical: isDesktop ? 20.h : 10.h,
        ),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 18.h : 14.h,
            ),
            side: BorderSide(
              color: product.isActive
                  ? AppColor.primaryColor
                  : AppColor.emptyColor,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isDesktop ? 15.r : 8.r),
            ),
          ),
          onPressed: product.isActive
              ? () {
                  CartController.instance.addItemToCart(product: product);
                  Get.back(); // Close bottom sheet after adding to cart
                }
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                product.isActive ? Icons.shopping_cart : Iconsax.close_circle,
                size: isDesktop ? 26.dm : 22.dm,
                color: product.isActive
                    ? AppColor.primaryColor
                    : AppColor.emptyColor,
              ),
              SizedBox(width: isDesktop ? 20.w : 15.w),
              Text(
                product.isActive ? "إضافة للسلة" : "نفدت الكمية",
                style: TextStyle(
                  fontSize: isDesktop ? 22.sp : 18.sp,
                  color: product.isActive
                      ? AppColor.primaryColor
                      : AppColor.emptyColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
