import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../futures/shop/model/category_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class CategoriesRepo extends GetxController {
  static CategoriesRepo get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getAllcategories() async {
    try {
      final snapshot = await _db.collection("Categories").get();
      final result =
          snapshot.docs.map((doc) => CategoryModel.fromSnapshot(doc)).toList();

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
  Stream<List<CategoryModel>> getAllcategoriesStream() {
    return _db
        .collection("Categories")
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CategoryModel.fromSnapshot(doc))
          .toList();
    });
  }
}
