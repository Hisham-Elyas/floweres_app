import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../auth/controller/profile_controller.dart';
import '../../../controller/notification/notification_controller.dart';
import 'widget/account_info_tab.dart';
import 'widget/notifications_tab.dart';
import 'widget/orders_tab.dart';
import 'widget/wishlist_tab.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final notificationController = Get.put(NotificationController());
    controller.loadUserInfo();

    return DefaultTabController(
      initialIndex: controller.selectedTab.value,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("حسابي"),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.edit),
              onPressed: () => Get.to(() => const EditProfileScreen()),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              const Tab(icon: Icon(Iconsax.user), text: "حسابي"),
              const Tab(icon: Icon(Iconsax.bag_2), text: "الطلبات"),
              const Tab(icon: Icon(Iconsax.heart), text: "المفضلة"),
              Tab(
                  icon: Obx(() {
                    return Badge(
                        isLabelVisible: true,
                        label: Text(
                            "${notificationController.notifications.length}"),
                        child: const Icon(Iconsax.notification));
                  }),
                  text: "الإشعارات"),
            ],
          ),
        ),
        body: Obx(() {
          return TabBarView(
            children: [
              AccountInfoTab(user: controller.user.value),
              const OrdersTab(),
              const WishlistTab(),
              const NotificationsTab(),
            ],
          );
        }),
      ),
    );
  }
}
