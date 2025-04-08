import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../auth/controller/profile_controller.dart';
import '../../../../model/user_model.dart';

class AccountInfoTab extends StatelessWidget {
  final UserModel user;
  const AccountInfoTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Iconsax.user, size: 40, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  user.fullName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.role.name == 'user' ? 'مستخدم' : 'مسؤول',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "معلومات الحساب",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          _buildInfoRow(Iconsax.user, "الاسم الكامل", user.fullName),
          _buildInfoRow(Iconsax.user_tag, "اسم المستخدم", user.userName),
          _buildInfoRow(Iconsax.sms, "البريد الإلكتروني", user.email),
          _buildInfoRow(Iconsax.call, "رقم الهاتف",
              user.phoneNumber.isNotEmpty ? user.phoneNumber : "غير محدد"),
          _buildInfoRow(Iconsax.calendar, "تاريخ الإنشاء",
              user.createdAt?.toString().substring(0, 10) ?? "غير محدد"),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () => Get.find<ProfileController>().signOut(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40),
              ),
              child: const Text("تسجيل الخروج"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل الملف الشخصي"),
        actions: [
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                await controller.updateProfile();
              }
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: controller.user.value.firstName,
                decoration: const InputDecoration(
                  labelText: "الاسم الأول",
                  prefixIcon: Icon(Iconsax.user),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "الرجاء إدخال الاسم الأول" : null,
                onSaved: (value) => controller.user.update((user) {
                  user?.firstName = value!;
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: controller.user.value.lastName,
                decoration: const InputDecoration(
                  labelText: "الاسم الأخير",
                  prefixIcon: Icon(Iconsax.user),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "الرجاء إدخال الاسم الأخير" : null,
                onSaved: (value) => controller.user.update((user) {
                  user?.lastName = value!;
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: controller.user.value.userName,
                decoration: const InputDecoration(
                  labelText: "اسم المستخدم",
                  prefixIcon: Icon(Iconsax.user_tag),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "الرجاء إدخال اسم المستخدم" : null,
                onSaved: (value) => controller.user.update((user) {
                  user?.userName = value!;
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: controller.user.value.phoneNumber,
                decoration: const InputDecoration(
                  labelText: "رقم الهاتف",
                  prefixIcon: Icon(Iconsax.call),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                onSaved: (value) => controller.user.update((user) {
                  user?.phoneNumber = value ?? '';
                }),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
