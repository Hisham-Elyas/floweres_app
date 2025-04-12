import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../app_coloer.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controller/cart/cart_controller.dart';
import '../../../controller/products/categories_products_details_controller.dart';
import '../../../controller/products/favorites_controller.dart';
import '../../../controller/products/products_controller.dart';
import '../../../model/products_model.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final productsController = Get.put(ProductsController());
    final isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;
    final isTablet =
        MediaQuery.of(context).size.width >= HSizes.tabletScreenSize &&
            MediaQuery.of(context).size.width < HSizes.desktopScreenSize;

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40.w : 25.w,
              vertical: isDesktop ? 15.h : 10.h,
            ),
            child: Row(
              children: [
                Text(
                  "All Products For Test",
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: isDesktop ? 24.sp : 20.sp,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: isDesktop ? 60.h : 50.h,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 15.w : 5.w,
                        vertical: 0,
                      ),
                      side: const BorderSide(
                        color: AppColor.secondaryColor,
                        width: 1,
                      ),
                    ),
                    onPressed: () {
                      final ctegoriesProductsDetailsController =
                          Get.put(CategoriesProductsDetailsController());
                      ctegoriesProductsDetailsController.items
                          .assignAll(productsController.allItems);
                      Get.toNamed(
                        HRoutes.categories,
                        arguments: "All Products For Test",
                      );
                    },
                    child: Text(
                      "See All",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 18.sp : 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Products List
          SizedBox(
            height: isDesktop ? 450.h : 350.h,
            child: isDesktop || isTablet
                ? GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 20.w : 10.w,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: isDesktop ? 380.w : 320.w,
                      mainAxisSpacing: isDesktop ? 20.w : 10.w,
                      crossAxisSpacing: isDesktop ? 20.h : 10.h,
                    ),
                    itemCount: productsController.allItems.length,
                    itemBuilder: (context, index) {
                      final product = productsController.allItems[index];
                      return ProductItem(
                        product: product,
                        isDesktop: isDesktop,
                      );
                    },
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    itemCount: productsController.allItems.length,
                    itemBuilder: (context, index) {
                      final product = productsController.allItems[index];
                      return ProductItem(
                        product: product,
                        isDesktop: isDesktop,
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.isDesktop,
  });

  final ProductsModel product;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final productsController = ProductsController.instance;

    return GestureDetector(
      onTap: () {
        productsController.showProductDestils(product: product);
      },
      child: Container(
        width: isDesktop ? 280.w : 200.w,
        margin: EdgeInsets.symmetric(
          horizontal: isDesktop ? 10.w : 5.w,
          vertical: isDesktop ? 10.h : 0,
        ),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          borderRadius: BorderRadius.circular(isDesktop ? 15.r : 10.r),
          boxShadow: isDesktop
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Column(
          children: [
            // Product Image
            Expanded(
              flex: isDesktop ? 3 : 2,
              child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isDesktop ? 15.r : 10.r),
                        topRight: Radius.circular(isDesktop ? 15.r : 10.r),
                      ),
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
                  ),

                  // Favorite and View Buttons
                  Positioned(
                    top: isDesktop ? 15 : 5,
                    right: isDesktop ? 15 : 5,
                    child: Column(
                      children: [
                        Obx(() {
                          final favoritesController =
                              Get.put(FavoritesController());
                          return GestureDetector(
                            onTap: () {
                              favoritesController.toggleFavorite(product);
                            },
                            child: Container(
                              height: isDesktop ? 50.dm : 40.dm,
                              width: isDesktop ? 50.dm : 40.dm,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 0.8,
                                  color: AppColor.primaryColor,
                                ),
                                color: Colors.white,
                              ),
                              child: Icon(
                                favoritesController.isFavorite(product)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: isDesktop ? 24.dm : 20.dm,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: isDesktop ? 15.h : 10.h),
                        GestureDetector(
                          onTap: () {
                            productsController.showProductDestils(
                              product: product,
                            );
                          },
                          child: Container(
                            height: isDesktop ? 50.dm : 40.dm,
                            width: isDesktop ? 50.dm : 40.dm,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.8,
                                color: AppColor.primaryColor,
                              ),
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.remove_red_eye_outlined,
                              size: isDesktop ? 24.dm : 20.dm,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Out of Stock Overlay
                  if (!product.isActive)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                        child: Center(
                          child: Transform.rotate(
                            angle: -0.5,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 20 : 10,
                                vertical: isDesktop ? 10 : 5,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.2,
                                  color: AppColor.emptyColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "نفدت الكمية",
                                style: TextStyle(
                                  color: AppColor.emptyColor,
                                  fontSize: isDesktop ? 28.sp : 24.sp,
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

            // Product Info
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 15.w : 8.w,
                vertical: isDesktop ? 15.h : 8.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isDesktop ? 16.sp : 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isDesktop ? 10.h : 5.h),
                  Text(
                    "SAR ${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isDesktop ? 20.sp : 18.sp,
                    ),
                  ),
                  SizedBox(height: isDesktop ? 15.h : 10.h),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(isDesktop ? 50.h : 40.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 15.w : 5.w,
                      ),
                      side: BorderSide(
                        color: product.isActive
                            ? AppColor.primaryColor
                            : Colors.grey,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          isDesktop ? 12.r : 8.r,
                        ),
                      ),
                    ),
                    onPressed: product.isActive
                        ? () {
                            CartController.instance.addItemToCart(
                              product: product,
                            );
                          }
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.card_travel,
                          size: isDesktop ? 26.dm : 22.dm,
                        ),
                        Text(
                          "إضافة للسلة",
                          style: TextStyle(
                            color: product.isActive
                                ? AppColor.primaryColor
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: isDesktop ? 20.sp : 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
