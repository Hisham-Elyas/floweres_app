import 'package:cached_network_image/cached_network_image.dart';
import 'package:floweres_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../app_coloer.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controller/cart/cart_controller.dart';
import '../../../model/cart_itme_model.dart';
import '../../widget/app_bar.dart';
import '../widget/breadcrumbs/breadcrumbs_with_heading.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    final dark = HHelperFunctions.isDarkMode(context);
    final isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;
    final isTablet =
        MediaQuery.of(context).size.width >= HSizes.tabletScreenSize;

    return Scaffold(
      appBar: const MyAppBar(),
      floatingActionButton: isDesktop
          ? cartController.cartItems.isNotEmpty
              ? _buildDesktopFloatingAction(cartController)
              : null
          : null,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 40.w : 16.w,
          vertical: 16.h,
        ),
        child: Obx(() {
          if (cartController.cartItems.isEmpty) {
            return _buildEmptyCart(dark, isDesktop);
          }

          if (isDesktop) {
            return _buildDesktopLayout(cartController);
          }

          return _buildMobileLayout(cartController, isTablet);
        }),
      ),
    );
  }

  Widget _buildDesktopLayout(CartController cartController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cart Items Grid
        Expanded(
          flex: 3,
          child: Column(
            children: [
              const HBreadcrumbsWithHeading(
                breadcrumbsItems: ["سلة المشتريات"],
              ),
              SizedBox(height: 24.h),
              _buildDesktopCartItemsGrid(cartController),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(CartController cartController, bool isTablet) {
    return Column(
      children: [
        const HBreadcrumbsWithHeading(
          breadcrumbsItems: ["سلة المشتريات"],
        ),
        SizedBox(height: isTablet ? 24.h : 16.h),
        Expanded(
          child: cartController.cartItems.isEmpty
              ? const SizedBox()
              : _buildMobileCartItemsList(cartController, false),
        ),
        if (cartController.cartItems.isNotEmpty)
          _buildMobileCartSummary(cartController, isTablet),
      ],
    );
  }

  Widget _buildDesktopCartItemsGrid(CartController cartController) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 4.h,
        ),
        itemCount: cartController.cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartController.cartItems[index];
          return MobileCartItem(
            isTablet: false,
            cartItem: cartItem,
            cartController: cartController,
          );
        },
      ),
    );
  }

  Widget _buildMobileCartItemsList(
      CartController cartController, bool isTablet) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, __) => SizedBox(height: isTablet ? 16.h : 12.h),
      itemCount: cartController.cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = cartController.cartItems[index];
        return MobileCartItem(
          cartItem: cartItem,
          cartController: cartController,
          isTablet: isTablet,
        );
      },
    );
  }

  Widget _buildMobileCartSummary(CartController cartController, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20.w : 16.w),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(HSizes.cardRadiusMd),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SAR ${cartController.totalAmountcartItems}",
                style: TextStyle(
                  fontSize: isTablet ? 24.sp : 20.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "الإجمالي",
                style: TextStyle(
                  fontSize: isTablet ? 24.sp : 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20.h : 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: isTablet ? 16.h : 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(HSizes.borderRadiusLg),
                ),
                backgroundColor: AppColor.primaryColor,
              ),
              onPressed: cartController.goToCheckoutScreen,
              child: Text(
                "اتمام الطلب",
                style: TextStyle(
                  fontSize: isTablet ? 18.sp : 16.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFloatingAction(CartController cartController) {
    return FloatingActionButton.extended(
      onPressed: cartController.goToCheckoutScreen,
      icon: const Icon(Iconsax.shopping_bag),
      label: Text(
        "اتمام الطلب (SAR ${cartController.totalAmountcartItems})",
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColor.primaryColor,
      foregroundColor: Colors.white,
    );
  }

  Widget _buildEmptyCart(bool dark, bool isDesktop) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.shopping_cart,
            size: isDesktop ? 80 : 60,
            color: dark ? HColors.darkerGrey : HColors.grey,
          ),
          SizedBox(height: isDesktop ? 24 : 16),
          Text(
            'سلة المشتريات فارغة',
            style: TextStyle(
              fontSize: isDesktop ? 22 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isDesktop ? 16 : 12),
          Text(
            'أضف بعض المنتجات لتبدأ التسوق',
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: dark ? HColors.darkerGrey : HColors.grey,
            ),
          ),
          SizedBox(height: isDesktop ? 30 : 24),
          OutlinedButton(
            onPressed: () => Get.offAllNamed(HRoutes.home),
            child: Text(
              'تصفح المنتجات',
              style: TextStyle(fontSize: isDesktop ? 18 : 16),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileCartItem extends StatelessWidget {
  final CartItemModel cartItem;
  final CartController cartController;
  final bool isTablet;

  const MobileCartItem({
    super.key,
    required this.cartItem,
    required this.cartController,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 16.w : 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HSizes.borderRadiusLg),
            border: Border.all(color: AppColor.primaryColor),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(HSizes.borderRadiusMd),
                    child: Container(
                      width: isTablet ? 100.w : 80.w,
                      height: isTablet ? 100.h : 80.h,
                      color: AppColor.primaryColor.withOpacity(0.1),
                      child: CachedNetworkImage(
                        imageUrl: cartItem.productImageUrl,
                        fit: BoxFit.contain,
                        progressIndicatorBuilder: (_, __, progress) => Center(
                          child: Skeletonizer(
                            child: Icon(
                              Iconsax.image,
                              size: isTablet ? 40 : 30,
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Icon(
                          Icons.error,
                          size: isTablet ? 40 : 30,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16.w : 12.w),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isTablet ? 18.sp : 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "SAR ${cartItem.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: isTablet ? 16.sp : 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16.h : 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SAR ${cartItem.totalAmount}",
                    style: TextStyle(
                      fontSize: isTablet ? 18.sp : 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => cartController
                            .decrementQuantity(cartItem.productId),
                        icon: Icon(Iconsax.minus, size: isTablet ? 24 : 20),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 16.w : 12.w,
                          vertical: isTablet ? 8.h : 4.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primaryColor),
                          borderRadius:
                              BorderRadius.circular(HSizes.borderRadiusSm),
                        ),
                        child: Text(
                          cartItem.quantity.toString(),
                          style: TextStyle(
                            fontSize: isTablet ? 16.sp : 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => cartController
                            .incrementQuantity(cartItem.productId),
                        icon: Icon(Iconsax.add, size: isTablet ? 24 : 20),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () => cartController.removeFromCart(cartItem.productId),
            icon: Icon(
              Iconsax.close_circle,
              size: isTablet ? 28 : 24,
              color: AppColor.emptyColor,
            ),
          ),
        ),
      ],
    );
  }
}
