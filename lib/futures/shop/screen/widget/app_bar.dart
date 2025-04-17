import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../auth/controller/profile_controller.dart';
import '../../controller/cart/cart_controller.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    return AppBar(
      title: Image.asset(
        "assets/images/logo.png",
        height: 50.h,
        fit: BoxFit.contain,
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
  Size get preferredSize => Size.fromHeight(
        HDeviceUtils.getAppBarHeight() *
            (Get.width >= HSizes.desktopScreenSize ? 1.5 : 1),
      );
}
