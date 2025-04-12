import 'package:cached_network_image/cached_network_image.dart';
import 'package:floweres_app/futures/shop/model/products_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../app_coloer.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../controller/cart/cart_controller.dart';
import '../../../../controller/products/favorites_controller.dart';
import '../../../../controller/products/products_controller.dart';

class WishlistTab extends StatelessWidget {
  const WishlistTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());
    final dark = HHelperFunctions.isDarkMode(context);
    final isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;
    final isTablet =
        MediaQuery.of(context).size.width >= HSizes.tabletScreenSize;

    return Scaffold(
      // appBar: AppBar(
      //     automaticallyImplyLeading: false,
      //     centerTitle: true,
      //     title: Text(
      //       'قائمة المفضلة',
      //       style: TextStyle(
      //         fontSize: isDesktop ? 24.sp : 20.sp,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     )),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.favorites.isEmpty) {
          return _buildEmptyState(dark, isDesktop);
        }

        return RefreshIndicator(
          onRefresh: () async => controller.loadFavorites(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40.w : HSizes.defaultSpace,
              vertical: isDesktop ? 20.h : HSizes.defaultSpace,
            ).copyWith(top: 0),
            child: GridView.builder(
              itemCount: controller.favorites.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 4 : (isTablet ? 3 : 2),
                mainAxisSpacing: isDesktop ? 24.h : HSizes.gridViewSpacing,
                crossAxisSpacing: isDesktop ? 24.w : HSizes.gridViewSpacing,
                mainAxisExtent: isDesktop ? 350.h : 240.h,
              ),
              itemBuilder: (_, index) {
                final product = controller.favorites[index];
                return _buildProductCard(
                  context,
                  product,
                  controller,
                  dark,
                  isDesktop,
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(bool dark, bool isDesktop) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.heart,
            size: isDesktop ? 80.dm : 50.dm,
            color: dark ? HColors.darkerGrey : HColors.grey,
          ),
          SizedBox(height: isDesktop ? 24.h : HSizes.spaceBtwItems),
          Text(
            'قائمة المفضلة فارغة',
            style: TextStyle(
              fontSize: isDesktop ? 22.sp : 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isDesktop ? 16.h : HSizes.sm),
          Text(
            'اضف منتجاتك المفضلة هنا',
            style: TextStyle(
              fontSize: isDesktop ? 16.sp : 14.sp,
              color: dark ? HColors.darkerGrey : HColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductsModel product,
    FavoritesController controller,
    bool dark,
    bool isDesktop,
  ) {
    return GestureDetector(
      onTap: () {
        Get.put(ProductsController());
        ProductsController.instance.showProductDestils(product: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: dark ? HColors.darkGrey : HColors.secondary,
          borderRadius: BorderRadius.circular(HSizes.cardRadiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(HSizes.cardRadiusMd),
                    topRight: Radius.circular(HSizes.cardRadiusMd),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    width: double.infinity,
                    height: isDesktop ? 200.h : 150.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                        child: Skeletonizer(
                      enableSwitchAnimation: true,
                      enabled: true,
                      child: Skeleton.shade(
                          child: Icon(
                        Iconsax.image,
                        size: isDesktop ? 80.dm : 60.dm,
                      )),
                    )),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(
                        Iconsax.box,
                        size: isDesktop ? 40.dm : 30.dm,
                        color: dark ? HColors.light : HColors.dark,
                      ),
                    ),
                  ),
                ),

                // Favorite Button
                Positioned(
                  top: isDesktop ? 12.h : 8.h,
                  right: isDesktop ? 12.w : 8.w,
                  child: IconButton(
                    icon: Icon(
                      Iconsax.heart5,
                      color: Colors.red,
                      size: isDesktop ? 28.dm : 24.dm,
                    ),
                    onPressed: () => controller.toggleFavorite(product),
                  ),
                ),

                // Out of Stock Indicator
                if (!product.isActive)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius:
                            BorderRadius.circular(HSizes.cardRadiusMd),
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 16.w : 10.w,
                              vertical: isDesktop ? 8.h : 5.h,
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

            // Product Details
            Padding(
              padding: EdgeInsets.all(isDesktop ? 16.w : HSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: isDesktop ? 18.sp : 16.sp,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isDesktop ? 8.h : HSizes.xs),
                  Row(
                    children: [
                      Text(
                        '${product.price.toStringAsFixed(2)} ر.س',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: isDesktop ? 20.sp : 18.sp,
                              fontWeight: FontWeight.bold,
                              color: HColors.primary,
                            ),
                      ),
                      const Spacer(),
                      if (product.isActive)
                        IconButton(
                          icon: Icon(
                            Iconsax.shopping_cart,
                            size: isDesktop ? 24.dm : 20.dm,
                            color: HColors.primary,
                          ),
                          onPressed: () {
                            Get.put(CartController());
                            CartController.instance
                                .addItemToCart(product: product);
                          },
                        ),
                    ],
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
