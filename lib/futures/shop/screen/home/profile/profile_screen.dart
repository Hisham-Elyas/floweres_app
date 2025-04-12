import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../auth/controller/profile_controller.dart';
import '../../../controller/notification/notification_controller.dart';
import '../../../controller/products/favorites_controller.dart';
import '../../widget/app_drawer.dart';
import '../widget/breadcrumbs/breadcrumbs_with_heading.dart';
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
    final favoritesController = Get.put(FavoritesController());

    return Scaffold(
      drawer: const MyDrawer(),
      // appBar: const MyAppBar(),

      appBar: AppBar(
        centerTitle: true,
        title: const Text("حسابي"),
        bottom: TabBar(
          controller: controller.tabController,
          isScrollable: true,
          tabs: [
            const Tab(icon: Icon(Iconsax.user), text: "حسابي"),
            const Tab(icon: Icon(Iconsax.bag_2), text: "الطلبات"),
            Tab(
              icon: Obx(() {
                return Badge(
                  isLabelVisible: favoritesController.favorites.isNotEmpty,
                  label: Text("${favoritesController.favorites.length}"),
                  child: const Icon(Iconsax.heart),
                );
              }),
              text: "المفضلة",
            ),
            Tab(
              icon: Obx(() {
                return Badge(
                  isLabelVisible: notificationController.unreadCount.value != 0,
                  label: Text("${notificationController.unreadCount.value}"),
                  child: const Icon(Iconsax.notification),
                );
              }),
              text: "الإشعارات",
            ),
          ],
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            const HBreadcrumbsWithHeading(breadcrumbsItems: ["حسابي"]),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  AccountInfoTab(user: controller.user.value),
                  const OrdersTab(),
                  const WishlistTab(),
                  const NotificationsTab(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
