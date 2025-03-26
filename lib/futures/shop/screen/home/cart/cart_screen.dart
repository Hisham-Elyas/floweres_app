import 'package:cached_network_image/cached_network_image.dart';
import 'package:floweres_app/futures/shop/model/cart_itme_model.dart';
import 'package:floweres_app/futures/shop/screen/home/widget/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../app_coloer.dart';
import '../../../controller/cart/cart_controller.dart';
import '../../widget/app_bar.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    return Scaffold(
      appBar: const MyAppBar(),
      // drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                const HBreadcrumbsWithHeading(
                    breadcrumbsItems: ["سلة المشتريات"]),
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 15.h),
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItme = cartController.cartItems[index];
                      return CartItemWidget(
                          cartItme: cartItme, cartController: cartController);
                    }),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SAR ${cartController.totalAmountcartItems}",
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w900,
                        )),
                    Text("  الإجمالي",
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                        backgroundColor: AppColor.primaryColor,
                      ),
                      onPressed: () {
                        Get.to(() => CheckoutScreen());
                      },
                      child: Text(
                        "اتمام الطلب",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
    required this.cartItme,
    required this.cartController,
  });

  final CartItemModel cartItme;
  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColor.primaryColor)),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 100.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                          height: 100.h,
                          color: AppColor.primaryColor.withOpacity(0.1),
                          child: CachedNetworkImage(
                            imageUrl: cartItme.productImageUrl,
                            fit: BoxFit.contain,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: Skeletonizer(
                                enableSwitchAnimation: true,
                                enabled: true,
                                child: Skeleton.shade(
                                    child: Icon(Iconsax.image, size: 100.dm)),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Center(child: Icon(Icons.error)),
                          )),
                    ),
                  ),
                  SizedBox(width: 15.h),
                  Column(
                    children: [
                      Text(cartItme.productName,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 5.h),
                      Text("SAR ${cartItme.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: 18.sp,
                          )),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text("SAR ${cartItme.totalAmount} : المجموع",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            cartController
                                .incrementQuantity(cartItme.productId);
                          },
                          icon: const Icon(Iconsax.add)),
                      Text(cartItme.quantity.toString(),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          )),
                      IconButton(
                          onPressed: () {
                            cartController
                                .decrementQuantity(cartItme.productId);
                          },
                          icon: const Icon(Iconsax.minus)),
                    ],
                  )
                ],
              ),
              Text("تاريخ التوصيل",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w900,
                  )),
              SizedBox(height: 55.h),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () {
              cartController.removeFromCart(cartItme.productId);
            },
            icon: Icon(
              Iconsax.close_circle,
              size: 32.dm,
              color: AppColor.emptyColor,
            ),
          ),
        ),
      ],
    );
  }
}
