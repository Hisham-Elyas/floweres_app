import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../auth/controller/profile_controller.dart';
import '../../controller/cart/cart_controller.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    return AppBar(
      title: CachedNetworkImage(
        height: 50.h,
        imageUrl:
            "https://cdn.salla.sa/form-builder/AxYPwEeamyUfaMJAnVot8a2HMLl0fQdjT6DbZRes.png",
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            Skeletonizer(
          enableSwitchAnimation: true,
          enabled: true,
          child: Skeleton.shade(child: Icon(Iconsax.image, size: 50.dm)),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      actions: [
        SizedBox(width: 5.w),
        IconButton(
          onPressed: () {
            final controler = Get.put(ProfileController());
            controler.openProfile();
          },
          icon: Icon(Icons.person_2_outlined,
              color: Theme.of(context).colorScheme.onSurface),
        ),
        IconButton(icon: Obx(() {
          return Badge(
            isLabelVisible: true,
            label: Text("${cartController.cartItems.length}"),
            child: Icon(Icons.shopping_cart_outlined,
                color: Theme.of(context).colorScheme.onSurface),
          );
        }), onPressed: () {
          Get.toNamed(HRoutes.cart);
        })
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(HDeviceUtils.getAppBarHeight());
}
