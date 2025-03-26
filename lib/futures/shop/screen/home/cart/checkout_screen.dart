import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../app_coloer.dart';
import '../../../../auth/controller/auth_controller.dart';
import '../../../controller/cart/cart_controller.dart';
import '../../../controller/cart/checkout_controller.dart';

class CheckoutScreen extends StatelessWidget {
  final CheckoutController controller = Get.put(CheckoutController());

  CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إتمام الطلب")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Text
            Row(
              children: [
                Text(
                  Get.put(AuthController()).user.value.fullName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                const Text(
                  "مرحباً بك",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Order Total & Coupon
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "SAR ${CartController.instance.totalAmountcartItems}",
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w900,
                            )),
                        const Text("إجمالي الطلب",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.couponController,
                      decoration: InputDecoration(
                        labelText: "أدخل رمز الكوبون",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Iconsax.discount_shape),
                          onPressed: controller.applyCoupon,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Shipping Address Section
            const Text("عنوان الشحن",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Shipping Method Selection
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: RadioListTile<int>(
                        value: 1,
                        groupValue: controller.selectedDeliveryMethod.value,
                        onChanged: (value) =>
                            controller.selectedDeliveryMethod.value = value!,
                        title: const Text("توصيل"),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<int>(
                        value: 2,
                        groupValue: controller.selectedDeliveryMethod.value,
                        onChanged: (value) =>
                            controller.selectedDeliveryMethod.value = value!,
                        title: const Text("إستلام من الفرع"),
                      ),
                    ),
                  ],
                )),

            const SizedBox(height: 10),

            // Address Form (Only if Home Delivery is selected)
            Obx(() => controller.selectedDeliveryMethod.value == 1
                ? _buildAddressForm(controller)
                : Container()),

            const SizedBox(height: 20),

            // Confirm Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.confirmOrder,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text("تأكيد الطلب",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Address Form Widget
  Widget _buildAddressForm(CheckoutController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("إضافة عنوان جديد",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Country Dropdown
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedCountry.value,
                  items: ["السعودية"]
                      .map((country) => DropdownMenuItem(
                          value: country, child: Text(country)))
                      .toList(),
                  onChanged: (value) =>
                      controller.selectedCountry.value = value!,
                  decoration: const InputDecoration(
                      labelText: "اختر الدولة", border: OutlineInputBorder()),
                )),
            const SizedBox(height: 10),

            // City Dropdown
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedCity.value,
                  items: ["الرياض", "جدة", "الدمام"]
                      .map((city) =>
                          DropdownMenuItem(value: city, child: Text(city)))
                      .toList(),
                  onChanged: (value) => controller.selectedCity.value = value!,
                  decoration: const InputDecoration(
                      labelText: "اختر المدينة", border: OutlineInputBorder()),
                )),
            const SizedBox(height: 10),

            // Street Name
            TextFormField(
              controller: controller.streetController,
              decoration: const InputDecoration(
                  labelText: "اسم الشارع", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),

            // District Name
            TextFormField(
              controller: controller.districtController,
              decoration: const InputDecoration(
                  labelText: "اسم الحي", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),

            // House Description
            TextFormField(
              controller: controller.houseDescController,
              decoration: const InputDecoration(
                  labelText: "وصف البيت (اختياري)",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),

            // Postal Code
            TextFormField(
              controller: controller.postalCodeController,
              decoration: const InputDecoration(
                  labelText: "الرمز البريدي", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {}, // Save address logic
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text("حفظ", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
