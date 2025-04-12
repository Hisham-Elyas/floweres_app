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
    final isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;
    final isTablet =
        MediaQuery.of(context).size.width >= HSizes.tabletScreenSize;

    return Drawer(
      width: isDesktop ? 300.w : null, // Fixed width for desktop
      elevation: isDesktop ? 0 : 4, // No shadow on desktop if side-by-side
      shape: isDesktop
          ? const RoundedRectangleBorder() // Standard rectangle for desktop
          : const BeveledRectangleBorder(), // Beveled for mobile
      child: Container(
        decoration: BoxDecoration(
          border: isDesktop
              ? null // No border for desktop if using sidebar
              : const Border(
                  right: BorderSide(color: HColors.grey, width: 1),
                ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Drawer Header
              DrawerHeader(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? HSizes.xl : HSizes.md,
                  vertical: isDesktop ? HSizes.xl : HSizes.md,
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://cdn.salla.sa/form-builder/AxYPwEeamyUfaMJAnVot8a2HMLl0fQdjT6DbZRes.png",
                  fit: BoxFit.contain,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Skeletonizer(
                    enableSwitchAnimation: true,
                    enabled: true,
                    child: Skeleton.shade(
                      child: Icon(
                        Iconsax.image,
                        size: isDesktop ? 80.dm : 60.dm,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error, size: isDesktop ? 80.dm : 60.dm),
                ),
              ),

              const SizedBox(height: HSizes.spaceBtwItems),

              // Menu Items
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? HSizes.xl : HSizes.md,
                  vertical: isDesktop ? HSizes.lg : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "MENU",
                      style: Theme.of(context).textTheme.bodySmall!.apply(
                            letterSpacingDelta: 1.2,
                            fontSizeFactor: isDesktop ? 1.2 : 1.0,
                          ),
                    ),
                    SizedBox(height: isDesktop ? HSizes.lg : HSizes.md),

                    // Categories List
                    Obx(() {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoriesController.allItems.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: HSizes.sm,
                        ),
                        itemBuilder: (context, index) => MenuItem(
                          icon: Iconsax.category_2,
                          itemName: categoriesController.allItems[index].name,
                          isActive: Get.currentRoute == HRoutes.categories &&
                              Get.arguments ==
                                  categoriesController.allItems[index].name,
                          onTap: () {
                            final ctegoriesProductsDetailsController =
                                Get.put(CategoriesProductsDetailsController());
                            ctegoriesProductsDetailsController
                                .getProductByCategories(
                              categoryId:
                                  categoriesController.allItems[index].id,
                            );

                            // Close drawer if open (mobile/tablet)
                            if ((scaffoldKey?.currentState?.isDrawerOpen ??
                                    false) &&
                                !isDesktop) {
                              Get.back();
                            }

                            // Navigate to category
                            Get.toNamed(
                              HRoutes.categories,
                              arguments:
                                  categoriesController.allItems[index].name,
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
