import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../routes/routes.dart';
import '../../controller/categories/categories_controller.dart';
import '../../controller/products/categories_products_details_controller.dart';
import 'drawer/menu_item.dart';

class MyDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const MyDrawer({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final categoriesController = Get.put(CategoriesController());
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
            // color: HColors.white,
            border: Border(
          right: BorderSide(color: HColors.grey, width: 1),
        )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                child: CachedNetworkImage(
                  imageUrl:
                      "https://cdn.salla.sa/form-builder/AxYPwEeamyUfaMJAnVot8a2HMLl0fQdjT6DbZRes.png",
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Skeletonizer(
                    enableSwitchAnimation: true,
                    enabled: true,
                    child:
                        Skeleton.shade(child: Icon(Iconsax.image, size: 60.dm)),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: HSizes.spaceBtwItems),
              Padding(
                padding: const EdgeInsets.all(HSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("MENU",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(letterSpacingDelta: 1.2)),

                    /// Menu Item
                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoriesController.allItems.length,
                        itemBuilder: (context, index) => MenuItem(
                          icon: Iconsax.category_2,
                          itemName: categoriesController.allItems[index].name,
                          onTap: () {
                            final ctegoriesProductsDetailsController =
                                Get.put(CategoriesProductsDetailsController());
                            ctegoriesProductsDetailsController
                                .getProductByCategories(
                              categoryId:
                                  categoriesController.allItems[index].id,
                            );
                            Get.toNamed(HRoutes.categories);
                            // Get.toNamed(HRoutes.cart);
                            scaffoldKey?.currentState?.closeDrawer();
                          },
                        ),
                      );
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
