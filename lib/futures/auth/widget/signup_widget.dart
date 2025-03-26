import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/popups/bottom_sheet.dart';
import '../../../utils/validators/validation.dart';
import '../controller/sign_up_controller.dart';
import 'login_widget.dart';

class SignupWidget extends StatelessWidget {
  const SignupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpController = Get.put(SignUpController());
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: HSizes.defaultSpace)
              .copyWith(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: Form(
            key: signUpController.loginFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: HSizes.spaceBtwInputFields * 2),
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        child: Icon(Icons.person_2),
                      ),
                      SizedBox(height: 20.h),
                      const Text("انشاء حساب"),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: signUpController.email,
                  validator: (value) => HValidator.validateEmail(value),
                  decoration: const InputDecoration(
                      labelText: "البريد الإلكتروني",
                      hintText: 'your@email.com'),
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields),
                TextFormField(
                  controller: signUpController.firstName,
                  validator: (value) => HValidator.validateUsername(value),
                  decoration: const InputDecoration(labelText: "الاسم الاول"),
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields),
                TextFormField(
                  controller: signUpController.lastName,
                  validator: (value) => HValidator.validateUsername(value),
                  decoration: const InputDecoration(labelText: "الاسم الاخر"),
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields),
                TextFormField(
                  controller: signUpController.phone,
                  validator: (value) =>
                      HValidator.validateEmptyText("رقم الهاتف", value),
                  decoration: const InputDecoration(labelText: "رقم الهاتف"),
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields),
                TextFormField(
                  controller: signUpController.password,
                  validator: (value) =>
                      HValidator.validateEmptyText('كلمة السر"', value),
                  decoration: const InputDecoration(
                    labelText: "كلمة السر",
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Get.back();
                      HBottomSheet.openBottomSheet(
                          child: const LoginWidget(), isScrollControlled: true);
                    },
                    child: const Text("لديك حساب ؟")),
                const SizedBox(height: HSizes.spaceBtwInputFields * 2),
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: signUpController.isLoading.value
                            ? null
                            : () async {
                                await signUpController.signUp();
                                Get.back();
                              },
                        child: signUpController.isLoading.value
                            ? const CircularProgressIndicator()
                            : const Text("انشاء")),
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
