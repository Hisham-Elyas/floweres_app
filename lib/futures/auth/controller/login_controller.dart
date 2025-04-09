import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/auth/auth_repo.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/loaders.dart';

class LoginController extends GetxController {
  final hidePassword = true.obs;
  final remeberMe = false.obs;
  final isLoading = false.obs;
  // final _localStorage = HLocalStorage.instance();

  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  // @override
  // void onInit() {
  //   email.text = _localStorage.readData("REMEBER_ME_EMAIL") ?? '';
  //   password.text = _localStorage.readData("REMEBER_ME_PASSWORD") ?? '';
  //   super.onInit();
  // }

  Future<void> login() async {
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
      await AuthRepo.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      HLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
