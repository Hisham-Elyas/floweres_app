import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widget/app_bar.dart';
import 'widget/banner_section.dart';
import 'widget/occasions_section.dart';
import 'widget/products_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CachedNetworkImage(
          height: 50.h,
          imageUrl:
              "https://cdn.salla.sa/form-builder/AxYPwEeamyUfaMJAnVot8a2HMLl0fQdjT6DbZRes.png",
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: Skeletonizer(
              enableSwitchAnimation: true,
              enabled: true,
              child: Skeleton.shade(child: Icon(Iconsax.image, size: 60.dm)),
            ),
          ),
          errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error)),
        ),
        actions: [
          // const Spacer(),
          Icon(Icons.search_outlined,
              color: Theme.of(context).colorScheme.onSurface),
          SizedBox(width: 5.w),
          Icon(Icons.person_2_outlined,
              color: Theme.of(context).colorScheme.onSurface),
          IconButton(
              icon: Badge(
                isLabelVisible: true,
                label: const Text("0"),
                child: Icon(Icons.shopping_cart_outlined,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              onPressed: () {})
        ],
      ),
      drawer: const MyAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // banner
              const BannerSection(),
              SizedBox(height: 10.h),
              // products Section Title
              const ProductsSection(),
              SizedBox(height: 10.h),

              // occasions Section
              const OccasionsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
