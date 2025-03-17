import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../futures/shop/model/banners_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BannersRepo extends GetxController {
  static BannersRepo get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<BannersModel>> getAllBanners() async {
    try {
      final snapshot = await _db
          .collection("Banners")
          .where('isActive', isEqualTo: true)
          .get();
      final result =
          snapshot.docs.map((doc) => BannersModel.fromSnapshot(doc)).toList();

      return result;
    } on FirebaseException catch (e) {
      throw HFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw HPlatformException(e.code).message;
    } catch (e) {
      throw "Someting went weong. pleas try agin";
    }
  }

  // Listen to real-time database updates
  Stream<List<BannersModel>> getAllBannersStream() {
    return _db
        .collection("Banners")
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BannersModel.fromSnapshot(doc))
          .toList();
    });
  }
}
