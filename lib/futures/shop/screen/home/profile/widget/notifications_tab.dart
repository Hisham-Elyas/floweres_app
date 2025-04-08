import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../controller/notification/notification_controller.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final dark = HHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Obx(() => Text(
              'الإشعارات (${controller.unreadCount.value})',
              style: Theme.of(context).textTheme.headlineSmall,
            )),
        actions: [
          TextButton(
            onPressed: controller.markAllAsRead,
            child: const Text('تعليم الكل كمقروء'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.notification,
                    size: 50, color: dark ? HColors.darkerGrey : HColors.grey),
                const SizedBox(height: HSizes.spaceBtwItems),
                Text(
                  'لا توجد إشعارات',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: HSizes.sm),
                Text(
                  'سيظهر هنا أي إشعارات جديدة تتلقاها',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(HSizes.defaultSpace),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: HSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final notification = controller.notifications[index];
            return Container(
              decoration: BoxDecoration(
                color: notification.isRead
                    ? Colors.transparent
                    : (dark
                        ? HColors.dark.withOpacity(0.4)
                        : HColors.primary.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(HSizes.cardRadiusMd),
                border:
                    Border.all(color: dark ? HColors.darkerGrey : HColors.grey),
              ),
              child: ListTile(
                onTap: () {
                  if (!notification.isRead) {
                    controller.markAsRead(notification.id);
                  }
                  // Handle notification tap (navigate to relevant screen)
                },
                leading: notification.imageUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(notification.imageUrl!),
                      )
                    : CircleAvatar(
                        child: Icon(
                          _getNotificationIcon(notification.type),
                          color: dark ? HColors.white : HColors.dark,
                        ),
                      ),
                title: Text(
                  notification.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.body,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: HSizes.sm),
                    Text(
                      DateFormat('dd/MM/yyyy hh:mm a')
                          .format(notification.createdAt),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                trailing: !notification.isRead
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: HColors.primary,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
            );
          },
        );
      }),
    );
  }

  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'order':
        return Iconsax.shopping_bag;
      case 'promotion':
        return Iconsax.discount_shape;
      case 'system':
        return Iconsax.info_circle;
      default:
        return Iconsax.notification;
    }
  }
}
