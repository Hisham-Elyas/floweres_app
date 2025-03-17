import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../app_coloer.dart';
import '../../../controller/banners/banners_controller.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bannersController = Get.put(BannersController());
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              // height: HResponsiveWidget.responsive(
              //   desktop: 950,
              //   tablet: 300,
              //   mobile: 200,
              // ),
              aspectRatio: 19.w / 6.w,
              autoPlay: true,
              enlargeCenterPage: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (index, reason) => {
                bannersController.position.value = index.toDouble(),
              },
            ),
            items: bannersController.filteredItems.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      color: AppColor.secondaryColor2,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: i.imageUrl,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: Skeletonizer(
                            enableSwitchAnimation: true,
                            enabled: true,
                            child: Skeleton.shade(
                                child: Icon(Iconsax.image, size: 60.dm)),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 10.h),
          DotsIndicator(
            dotsCount: bannersController.filteredItems.isNotEmpty
                ? bannersController.filteredItems.length
                : 3,
            position: bannersController.isLoading.value
                ? 1
                : bannersController.position.value,
            animate: true,
            decorator: DotsDecorator(
              activeColor: AppColor.primaryColor,
              color: AppColor.secondaryColor,
              size: const Size(20.0, 8.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0.r)),
              activeSize: const Size(20.0, 8.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0.r)),
            ),
          )
        ],
      ),
    );
  }
}
