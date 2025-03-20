import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../app_coloer.dart';
import '../../../controller/cart/cart_controller.dart';
import '../../widget/app_bar.dart';
import '../../widget/app_drawer.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 15.h),
                    itemCount: cartController.cartItmes.length,
                    itemBuilder: (context, index) {
                      final cartItme = cartController.cartItmes[index];
                      return Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border:
                                    Border.all(color: AppColor.primaryColor)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 100.h,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: Container(
                                            height: 100.h,
                                            color: AppColor.primaryColor
                                                .withOpacity(0.1),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  cartItme.productImageUrl,
                                              fit: BoxFit.contain,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Center(
                                                child: Skeletonizer(
                                                  enableSwitchAnimation: true,
                                                  enabled: true,
                                                  child: Skeleton.shade(
                                                      child: Icon(Iconsax.image,
                                                          size: 100.dm)),
                                                ),
                                              ),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  const Center(
                                                      child: Icon(Icons.error)),
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
                                        Text(
                                            "SAR ${cartItme.price.toStringAsFixed(2)}",
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
                                    Text(
                                        "SAR ${cartItme.totalAmount} : المجموع",
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
                                              if (cartItme.quantity < 10) {
                                                cartItme.quantity++;
                                                cartController.cartItmes
                                                    .refresh();
                                              }
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
                                              if (cartItme.quantity > 1) {
                                                cartItme.quantity--;
                                                cartController.cartItmes
                                                    .refresh();
                                              }
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
                                cartController.cartItmes.remove(cartItme);
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
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "SAR ${cartController.cartItmes.fold(0.0, (previousValue, element) => previousValue + double.parse(element.totalAmount))} : المجموع",
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w900,
                      )),
                  Text(" : الإجمالي",
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w900,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
