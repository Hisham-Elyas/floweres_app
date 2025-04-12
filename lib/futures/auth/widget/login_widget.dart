import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/popups/bottom_sheet.dart';
import '../../../utils/validators/validation.dart';
import '../controller/login_controller.dart';
import 'signup_widget.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: HSizes.defaultSpace)
              .copyWith(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: Form(
            key: loginController.loginFormKey,
            child: Column(
              children: [
                const SizedBox(height: HSizes.spaceBtwInputFields * 2),
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        child: Icon(Icons.person_2),
                      ),
                      SizedBox(height: 20.h),
                      const Text('تسجيل الدخول'),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: loginController.email,
                  validator: (value) => HValidator.validateEmail(value),
                  decoration: const InputDecoration(
                      labelText: "البريد الإلكتروني",
                      hintText: 'your@email.com'),
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields),
                TextFormField(
                  controller: loginController.password,
                  validator: (value) =>
                      HValidator.validateEmptyText('كلمة السر"', value),
                  decoration: const InputDecoration(
                    labelText: "كلمة السر",
                  ),
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields),
                TextButton(
                    onPressed: () {
                      Get.back();
                      HBottomSheet.openBottomSheet(
                          child: const SignupWidget(),
                          isScrollControlled: true);
                    },
                    child: const Text("ليس لديك حساب ؟")),
                const SizedBox(height: HSizes.spaceBtwInputFields * 2),
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          await loginController.login();
                          Get.back();
                        },
                        child: loginController.isLoading.value
                            ? const CircularProgressIndicator()
                            : const Text("دخول")),
                  );
                }),
                const SizedBox(height: HSizes.spaceBtwInputFields * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
