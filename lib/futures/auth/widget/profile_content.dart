import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../app_coloer.dart';
import '../../../routes/routes.dart';
import '../controller/profile_controller.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(ProfileController());
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with Profile
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Iconsax.user, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("مرحباً بك",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Obx(
                      () => Text(authController.user.value.fullName,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey)),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Iconsax.close_circle,
                    color: AppColor.emptyColor),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),

          // Menu Items

          // _buildMenuItem(Iconsax.timer, "طلبات بانتظار الدفع", onTap: () {}),
          _buildMenuItem(Iconsax.notification, "الاشعارات", onTap: () {
            // الاشعارات
            ProfileController.instance.changeTab(3);
            Get.toNamed(HRoutes.profileScreen);
          }),
          _buildMenuItem(Iconsax.bag_tick, "الطلبات", onTap: () {
            ProfileController.instance.changeTab(1); // tab index for "الطلبات"
            Get.toNamed(HRoutes.profileScreen);
          }),
          _buildMenuItem(Iconsax.heart, "المفصلة", onTap: () {
            // الأمنيات
            ProfileController.instance.changeTab(2);
            Get.toNamed(HRoutes.profileScreen);
          }),
          _buildMenuItem(Iconsax.user_edit, "حسابي", onTap: () {
            // حسابي
            ProfileController.instance.changeTab(0);
            Get.toNamed(HRoutes.profileScreen);
          }),
          _buildMenuItem(
            Iconsax.logout,
            "تسجيل الخروج",
            isLogout: true,
            onTap: () {
              authController.signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title,
      {bool isLogout = false, void Function()? onTap}) {
    return ListTile(
      leading: Icon(icon,
          color: isLogout ? AppColor.emptyColor : AppColor.primaryColor),
      title: Text(title,
          style:
              TextStyle(color: isLogout ? AppColor.emptyColor : Colors.black)),
      onTap: onTap,
    );
  }
}
