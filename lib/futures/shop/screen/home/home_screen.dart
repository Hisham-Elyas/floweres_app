import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/constants/sizes.dart';
import '../widget/app_bar.dart';
import '../widget/app_drawer.dart';
import 'widget/banner_section.dart';
import 'widget/occasions_section.dart';
import 'widget/products_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;
    final bool isTablet =
        MediaQuery.of(context).size.width >= HSizes.tabletScreenSize &&
            MediaQuery.of(context).size.width < HSizes.desktopScreenSize;
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isDesktop ? 20.h : 8.w,
            horizontal: isDesktop ? 40.w : 8.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // banner
              const BannerSection(),
              SizedBox(height: isDesktop ? 30.h : 10.h),
              // products Section Title
              const ProductsSection(),
              SizedBox(height: isDesktop ? 30.h : 10.h),

              // occasions Section
              const OccasionsSection(),
              if (isDesktop) SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
