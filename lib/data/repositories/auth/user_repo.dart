import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../futures/shop/model/user_model.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/local_storage/storage_utility.dart';
import 'auth_repo.dart';

class UserRepo extends GetxController {
  static UserRepo get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _storage = HLocalStorage.instance();
  void removeUserInfo() {
    _storage.removeData('USER_INFO');
  }

  void saveUserInfo({required UserModel user}) {
    _storage.writeData<Map<String, dynamic>>('USER_INFO', user.toJson());
  }

  UserModel? loadUserInfo() {
    Map<String, dynamic>? storedUserInfo = _storage.readData('USER_INFO');
    if (storedUserInfo != null) {
      return UserModel.fromJson(storedUserInfo);
    }
    return null;
  }

  Future<void> createUser({required UserModel user}) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toMap());
      saveUserInfo(user: user);
    } on FirebaseAuthException catch (e) {
      throw HFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw HFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const HFormatException();
    } on PlatformException catch (e) {
      throw HPlatformException(e.code).message;
    } catch (e) {
      throw "Someting went weong. pleas try agin";
    }
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      final docSnapshot = await _db
          .collection("Users")
          .doc(AuthRepo.instance.authUser!.uid)
          .get();
      final user = UserModel.fromSnapshot(docSnapshot);
      saveUserInfo(user: user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw HFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw HFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const HFormatException();
    } on PlatformException catch (e) {
      throw HPlatformException(e.code).message;
    } catch (e) {
      throw "Someting went weong. pleas try agin";
    }
  }
}
