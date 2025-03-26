import 'package:floweres_app/futures/shop/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/auth/auth_repo.dart';
import '../../../data/repositories/auth/user_repo.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/local_storage/storage_utility.dart';
import '../../../utils/popups/loaders.dart';

class SignUpController extends GetxController {
  final hidePassword = true.obs;
  final isLoading = false.obs;
  final remeberMe = false.obs;
  final _storage = HLocalStorage.instance();

  final email = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  Future<void> signUp() async {
    try {
      isLoading.value = true;
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }
      if (!loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }
      final userdata = await AuthRepo.instance.signUpWithEmailAndPassword(
          email: email.text, password: password.text);
      final UserRepo userRepo = Get.put(UserRepo());
      userRepo.createUser(
          user: UserModel(
        email: email.text.trim(),
        id: userdata.user!.uid,
        phoneNumber: phone.text.trim(),
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        userName: firstName.text.trim(),
      ));
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      HLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
