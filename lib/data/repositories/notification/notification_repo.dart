// repositories/notification_repo.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../../../futures/shop/model/notification_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../auth/auth_repo.dart';

class NotificationRepository {
  final _db = FirebaseFirestore.instance;

  // Get user notifications stream
  Stream<List<NotificationModel>> getUserNotifications() {
    final userId = AuthRepo.instance.authUser?.uid;
    if (userId == null) throw 'User not authenticated';

    return _db
        .collection('Notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromSnapshot(doc))
          .toList();
    });
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _db.collection('Notifications').doc(notificationId).update({
        'isRead': true,
      });
    } on FirebaseException catch (e) {
      throw HFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw HPlatformException(e.code).message;
    } catch (e) {
      throw "Someting went weong. pleas try agin";
    }
  }
}
