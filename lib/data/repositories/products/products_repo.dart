import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../futures/shop/model/products_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class ProductsRepo extends GetxController {
  static ProductsRepo get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ProductsModel>> getAllProducts() async {
    try {
      final snapshot = await _db.collection("Products").get();
      final result =
          snapshot.docs.map((doc) => ProductsModel.fromSnapshot(doc)).toList();

      return result;
    } on FirebaseException catch (e) {
      throw HFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw HPlatformException(e.code).message;
    } catch (e) {
      log(e.toString());
      throw "Someting went weong. pleas try agin";
    }
  }

  Future<List<ProductsModel>> getAllProductsByCategories(
      {required String categoryId}) async {
    try {
      final snapshot = await _db
          .collection("Products")
          .where("categoriesIds", arrayContains: categoryId)
          .get();
      final result =
          snapshot.docs.map((doc) => ProductsModel.fromSnapshot(doc)).toList();

      return result;
    } on FirebaseException catch (e) {
      throw HFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw HPlatformException(e.code).message;
    } catch (e) {
      log(e.toString());
      throw "Someting went weong. pleas try agin";
    }
  }

  // Listen to real-time database updates
  Stream<List<ProductsModel>> getAllProductsStream() {
    return _db
        .collection("Products")
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductsModel.fromSnapshot(doc))
          .toList();
    });
  }
}
