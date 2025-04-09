import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../futures/shop/model/order_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../auth/auth_repo.dart';

class OrderRepo extends GetxController {
  static OrderRepo get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future createOrder({required OrderModel order}) async {
    try {
      await _db.collection("Orders").add(order.toMap());
    } on FirebaseException catch (e) {
      throw HFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw HPlatformException(e.code).message;
    } catch (e) {
      throw "Someting went weong. pleas try agin";
    }
  }

  // Listen to real-time database updates
  Stream<List<OrderModel>> getAllOrderStream() {
    return _db
        .collection("Orders")
        .where('userId', isEqualTo: AuthRepo.instance.authUser!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
    });
  }
}
