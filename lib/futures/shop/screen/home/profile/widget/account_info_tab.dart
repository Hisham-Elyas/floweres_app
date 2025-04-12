import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../auth/controller/profile_controller.dart';
import '../../../../model/user_model.dart';

class AccountInfoTab extends StatelessWidget {
  final UserModel user;
  const AccountInfoTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = HHelperFunctions.isDarkMode(context);
    final isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40.w : 16.w,
        vertical: 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: isDesktop ? 70.r : 50.r,
                  backgroundColor: isDark ? HColors.darkGrey : HColors.light,
                  child: Icon(
                    Iconsax.user,
                    size: isDesktop ? 50.dm : 40.dm,
                    color: isDark ? HColors.light : HColors.darkGrey,
                  ),
                ),
                SizedBox(height: isDesktop ? 16.h : 10.h),
                IconButton(
                  icon: const Icon(Iconsax.edit),
                  onPressed: () => Get.toNamed('/edit-profile'),
                ),
                SizedBox(height: isDesktop ? 16.h : 10.h),
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontSize: isDesktop ? 24.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  user.role.name == 'user' ? 'مستخدم' : 'مسؤول',
                  style: TextStyle(
                    fontSize: isDesktop ? 16.sp : 14.sp,
                    color: HColors.darkerGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isDesktop ? 30.h : 20.h),

          // Account Information
          Text(
            "معلومات الحساب",
            style: TextStyle(
              fontSize: isDesktop ? 22.sp : 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(color: isDark ? HColors.darkGrey : HColors.grey),
          SizedBox(height: isDesktop ? 20.h : 12.h),

          // Info Rows
          _buildInfoRow(
            context,
            Iconsax.user,
            "الاسم الكامل",
            user.fullName,
            isDesktop: isDesktop,
          ),
          _buildInfoRow(
            context,
            Iconsax.user_tag,
            "اسم المستخدم",
            user.userName,
            isDesktop: isDesktop,
          ),
          _buildInfoRow(
            context,
            Iconsax.sms,
            "البريد الإلكتروني",
            user.email,
            isDesktop: isDesktop,
          ),
          _buildInfoRow(
            context,
            Iconsax.call,
            "رقم الهاتف",
            user.phoneNumber.isNotEmpty ? user.phoneNumber : "غير محدد",
            isDesktop: isDesktop,
          ),
          _buildInfoRow(
            context,
            Iconsax.calendar,
            "تاريخ الإنشاء",
            user.createdAt?.toString().substring(0, 10) ?? "غير محدد",
            isDesktop: isDesktop,
          ),
          SizedBox(height: isDesktop ? 40.h : 30.h),

          // Logout Button
          Center(
            child: ElevatedButton(
              onPressed: () => Get.find<ProfileController>().signOut(),
              style: ElevatedButton.styleFrom(
                backgroundColor: HColors.error,
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 60.w : 40.w,
                  vertical: isDesktop ? 16.h : 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isDesktop ? 12.r : 8.r),
                ),
              ),
              child: Text(
                "تسجيل الخروج",
                style: TextStyle(
                  fontSize: isDesktop ? 18.sp : 16.sp,
                  color: HColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String title,
    String value, {
    required bool isDesktop,
  }) {
    final isDark = HHelperFunctions.isDarkMode(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 16.h : 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: isDesktop ? 24.dm : 20.dm,
            color: HColors.primary,
          ),
          SizedBox(width: isDesktop ? 20.w : 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isDesktop ? 16.sp : 14.sp,
                    color: HColors.darkerGrey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isDesktop ? 18.sp : 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? HColors.light : HColors.dark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;
    final controller = Get.find<ProfileController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تعديل الملف الشخصي",
          style: TextStyle(fontSize: isDesktop ? 22.sp : 18.sp),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: isDesktop ? 40.w : 16.w),
            child: TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  await controller.updateProfile();
                }
              },
              child: Text(
                "حفظ",
                style: TextStyle(
                  fontSize: isDesktop ? 18.sp : 16.sp,
                  color: HColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 40.w : 16.w,
          vertical: 16.h,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: isDesktop ? 20.h : 10.h),
              TextFormField(
                initialValue: controller.user.value.firstName,
                decoration: InputDecoration(
                  labelText: "الاسم الأول",
                  prefixIcon:
                      Icon(Iconsax.user, size: isDesktop ? 24.dm : 20.dm),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isDesktop ? 12.r : 8.r),
                  ),
                ),
                style: TextStyle(fontSize: isDesktop ? 18.sp : 16.sp),
                validator: (value) =>
                    value!.isEmpty ? "الرجاء إدخال الاسم الأول" : null,
                onSaved: (value) => controller.user.update((user) {
                  user?.firstName = value!;
                }),
              ),
              SizedBox(height: isDesktop ? 20.h : 16.h),
              TextFormField(
                initialValue: controller.user.value.lastName,
                decoration: InputDecoration(
                  labelText: "الاسم الأخير",
                  prefixIcon:
                      Icon(Iconsax.user, size: isDesktop ? 24.dm : 20.dm),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isDesktop ? 12.r : 8.r),
                  ),
                ),
                style: TextStyle(fontSize: isDesktop ? 18.sp : 16.sp),
                validator: (value) =>
                    value!.isEmpty ? "الرجاء إدخال الاسم الأخير" : null,
                onSaved: (value) => controller.user.update((user) {
                  user?.lastName = value!;
                }),
              ),
              SizedBox(height: isDesktop ? 20.h : 16.h),
              TextFormField(
                initialValue: controller.user.value.userName,
                decoration: InputDecoration(
                  labelText: "اسم المستخدم",
                  prefixIcon:
                      Icon(Iconsax.user_tag, size: isDesktop ? 24.dm : 20.dm),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isDesktop ? 12.r : 8.r),
                  ),
                ),
                style: TextStyle(fontSize: isDesktop ? 18.sp : 16.sp),
                validator: (value) =>
                    value!.isEmpty ? "الرجاء إدخال اسم المستخدم" : null,
                onSaved: (value) => controller.user.update((user) {
                  user?.userName = value!;
                }),
              ),
              SizedBox(height: isDesktop ? 20.h : 16.h),
              TextFormField(
                initialValue: controller.user.value.phoneNumber,
                decoration: InputDecoration(
                  labelText: "رقم الهاتف",
                  prefixIcon:
                      Icon(Iconsax.call, size: isDesktop ? 24.dm : 20.dm),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isDesktop ? 12.r : 8.r),
                  ),
                ),
                style: TextStyle(fontSize: isDesktop ? 18.sp : 16.sp),
                keyboardType: TextInputType.phone,
                onSaved: (value) => controller.user.update((user) {
                  user?.phoneNumber = value ?? '';
                }),
              ),
              SizedBox(height: isDesktop ? 40.h : 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
