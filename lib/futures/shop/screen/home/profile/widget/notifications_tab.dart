import 'package:floweres_app/futures/auth/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../controller/notification/notification_controller.dart';
import '../../../../controller/order/order_controller.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final dark = HHelperFunctions.isDarkMode(context);
    final isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Obx(() => Text(
      //         'الإشعارات (${controller.unreadCount.value})',
      //         style: Theme.of(context).textTheme.headlineSmall?.copyWith(
      //               fontSize: isDesktop ? 24.sp : 18.sp,
      //             ),
      //       )),
      //   actions: [
      //     Padding(
      //       padding: EdgeInsets.only(right: isDesktop ? 40.w : 16.w),
      //       child: TextButton(
      //         onPressed: controller.markAllAsRead,
      //         child: Text(
      //           'تعليم الكل كمقروء',
      //           style: TextStyle(
      //             fontSize: isDesktop ? 16.sp : 14.sp,
      //             color: HColors.primary,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.notification,
                  size: isDesktop ? 80.dm : 50.dm,
                  color: dark ? HColors.darkerGrey : HColors.grey,
                ),
                SizedBox(height: isDesktop ? 24.h : HSizes.spaceBtwItems),
                Text(
                  'لا توجد إشعارات',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: isDesktop ? 22.sp : 18.sp,
                      ),
                ),
                SizedBox(height: isDesktop ? 16.h : HSizes.sm),
                Text(
                  'سيظهر هنا أي إشعارات جديدة تتلقاها',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: isDesktop ? 16.sp : 14.sp,
                      ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40.w : HSizes.defaultSpace,
            vertical: isDesktop ? 20.h : HSizes.defaultSpace,
          ),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) =>
              SizedBox(height: isDesktop ? 20.h : HSizes.spaceBtwItems),
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
                border: Border.all(
                  color: dark ? HColors.darkerGrey : HColors.grey,
                  width: notification.isRead ? 0.5 : 1,
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 24.w : 16.w,
                  vertical: isDesktop ? 16.h : 12.h,
                ),
                onTap: () {
                  if (!notification.isRead) {
                    controller.markAsRead(notification.id);
                  }
                  final ordersController = Get.put(OrdersController());

// Change to the Orders tab
                  final profilrController = Get.find<ProfileController>();
                  profilrController.changeTab(1);

// Then scroll and expand
                  Future.delayed(const Duration(milliseconds: 400), () {
                    ordersController
                        .setSelectedOrderId(notification.data!['orderId']);
                  });
                },
                leading: notification.imageUrl != null
                    ? CircleAvatar(
                        radius: isDesktop ? 28.r : 24.r,
                        backgroundImage: NetworkImage(notification.imageUrl!),
                      )
                    : CircleAvatar(
                        radius: isDesktop ? 28.r : 24.r,
                        backgroundColor:
                            dark ? HColors.darkGrey : HColors.light,
                        child: Icon(
                          _getNotificationIcon(notification.type),
                          size: isDesktop ? 24.dm : 20.dm,
                          color: dark ? HColors.white : HColors.dark,
                        ),
                      ),
                title: Text(
                  notification.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: isDesktop ? 18.sp : 16.sp,
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isDesktop ? 8.h : 4.h),
                    Text(
                      notification.body,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: isDesktop ? 16.sp : 14.sp,
                          ),
                    ),
                    SizedBox(height: isDesktop ? 12.h : HSizes.sm),
                    Text(
                      DateFormat('dd/MM/yyyy hh:mm a')
                          .format(notification.createdAt),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: isDesktop ? 14.sp : 12.sp,
                          ),
                    ),
                  ],
                ),
                trailing: !notification.isRead
                    ? Container(
                        width: isDesktop ? 12.w : 10.w,
                        height: isDesktop ? 12.h : 10.h,
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
      case 'message':
        return Iconsax.message;
      case 'payment':
        return Iconsax.wallet;
      default:
        return Iconsax.notification;
    }
  }
}
