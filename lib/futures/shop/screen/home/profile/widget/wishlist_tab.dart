import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../app_coloer.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../controller/products/favorites_controller.dart';

class WishlistTab extends StatelessWidget {
  const WishlistTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());
    final dark = HHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Obx(() {
        if (controller.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.heart,
                    size: 50, color: dark ? HColors.darkerGrey : HColors.grey),
                const SizedBox(height: HSizes.spaceBtwItems),
                Text(
                  'قائمة المفضلة فارغة',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: HSizes.sm),
                Text(
                  'اضف منتجاتك المفضلة هنا',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(HSizes.defaultSpace),
          child: GridView.builder(
            itemCount: controller.favorites.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: HSizes.gridViewSpacing,
              crossAxisSpacing: HSizes.gridViewSpacing,
              mainAxisExtent: 220,
            ),
            itemBuilder: (_, index) {
              final product = controller.favorites[index];
              return Container(
                decoration: BoxDecoration(
                  color: dark ? HColors.darkGrey : HColors.secondary,
                  borderRadius: BorderRadius.circular(HSizes.cardRadiusMd),
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
                          child: Image.network(
                            product.imageUrl,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Iconsax.box),
                          ),
                        ),

                        // Favorite Button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(
                              Iconsax.heart5,
                              color: Colors.red,
                              size: 24,
                            ),
                            onPressed: () => controller.toggleFavorite(product),
                          ),
                        ),

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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
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
                                        fontSize: 24.sp,
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
                      padding: const EdgeInsets.all(HSizes.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.labelLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: HSizes.xs),
                          Row(
                            children: [
                              Text(
                                '${product.price.toStringAsFixed(2)} ر.س',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
