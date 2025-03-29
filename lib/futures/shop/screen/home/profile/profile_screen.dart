import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app_coloer.dart';
import '../../../../auth/controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الرئيسية : حسابي ، الطلبات",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavigationTabs(),
            _buildContentArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTabs() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabButton("الاشعارات", 0),
              _buildTabButton("الطلبات", 1),
              _buildTabButton("المفصلة", 2),
            ],
          ),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => controller.changeTab(index),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: controller.selectedTab.value == index
                    ? AppColor.primaryColor
                    : Colors.grey[600],
              ),
            ),
          ),
          Container(
            height: 2.h,
            width: 40.w,
            color: controller.selectedTab.value == index
                ? AppColor.primaryColor
                : Colors.transparent,
          )
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: TextButton(
        onPressed: controller.logout,
        child: Text(
          "تسجيل الخروج",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.red,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildContentArea() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(16.w),
        height: 500.h,
        child: _getSelectedContent(),
      ),
    );
  }

  Widget _getSelectedContent() {
    switch (controller.selectedTab.value) {
      case 0:
        return _buildNotificationsContent();
      case 1:
        return _buildOrdersContent();
      case 2:
        return _buildDetailsContent();
      default:
        return Container();
    }
  }

  Widget _buildOrdersContent() {
    return Center(
      child: Text(
        "لا يوجد طلبات",
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildNotificationsContent() => const Placeholder();
  Widget _buildDetailsContent() => const Placeholder();
}
