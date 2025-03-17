import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../futures/shop/model/occasions_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class OccasionsRepo extends GetxController {
  static OccasionsRepo get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<OccasionsModel>> getAllOccasions() async {
    try {
      final snapshot = await _db.collection("Occasions").get();
      final result =
          snapshot.docs.map((doc) => OccasionsModel.fromSnapshot(doc)).toList();

      return result;
    } on FirebaseException catch (e) {
      throw HFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw HPlatformException(e.code).message;
    } catch (e) {
      throw "Someting went weong. pleas try agin";
    }
  }

  // Listen to real-time data updates
  Stream<List<OccasionsModel>> getAllOccasionsStream() {
    return _db
        .collection("Occasions")
        .orderBy('name')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OccasionsModel.fromSnapshot(doc))
          .toList();
    });
  }
}
