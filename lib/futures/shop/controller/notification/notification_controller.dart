// controllers/notifications/notification_controller.dart
import 'package:get/get.dart';

import '../../../../data/repositories/notification/notification_repo.dart';
import '../../model/notification_model.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  final _notificationRepo = NotificationRepository();
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      _notificationRepo.getUserNotifications().listen((notificationsList) {
        notifications.assignAll(notificationsList);
        // notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        unreadCount.value = notifications.where((n) => !n.isRead).length;
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationRepo.markAsRead(notificationId);
      unreadCount.value = notifications.where((n) => !n.isRead).length;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final unreadIds =
          notifications.where((n) => !n.isRead).map((n) => n.id).toList();

      for (final id in unreadIds) {
        await _notificationRepo.markAsRead(id);
      }

      unreadCount.value = 0;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
