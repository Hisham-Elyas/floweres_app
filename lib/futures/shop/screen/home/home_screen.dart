import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/app_bar.dart';
import '../widget/app_drawer.dart';
import 'widget/banner_section.dart';
import 'widget/occasions_section.dart';
import 'widget/products_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
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
