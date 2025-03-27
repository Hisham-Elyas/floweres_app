import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../app_coloer.dart';
import '../../../../auth/controller/profile_controller.dart';
import '../../../controller/cart/cart_controller.dart';
import '../../../controller/cart/checkout_controller.dart';
import '../../../model/address_model.dart';

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
                  Get.put(ProfileController()).user.value.fullName,
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
                    // TextField(
                    //   controller: controller.couponController,
                    //   decoration: InputDecoration(
                    //     labelText: "أدخل رمز الكوبون",
                    //     border: const OutlineInputBorder(),
                    //     suffixIcon: IconButton(
                    //       icon: const Icon(Iconsax.discount_shape),
                    //       onPressed: controller.applyCoupon,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                child: Column(
                  children: [
                    // Shipping Address Section
                    Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Text("عنوان الشحن",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Shipping Method Selection
                    Obx(() => Row(
                          children: [
                            Expanded(
                              child: RadioListTile<int>(
                                value: 1,
                                activeColor: AppColor.primaryColor,
                                groupValue:
                                    controller.selectedDeliveryMethod.value,
                                onChanged: (value) => controller
                                    .selectedDeliveryMethod.value = value!,
                                title: const Text("توصيل"),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<int>(
                                value: 2,
                                activeColor: AppColor.primaryColor,
                                groupValue:
                                    controller.selectedDeliveryMethod.value,
                                onChanged: (value) => controller
                                    .selectedDeliveryMethod.value = value!,
                                title: const Text("إستلام من الفرع"),
                              ),
                            ),
                          ],
                        )),

                    const SizedBox(height: 10),

                    // Address Form (Only if Home Delivery is selected)
                    Obx(() => controller.selectedDeliveryMethod.value == 1
                        ? _buildAddress(controller)
                        : _buildBranchDetails()),

                    const SizedBox(height: 20),

                    // Confirm Order Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.confirmOrder,
                        child: const Text("تأكيد الطلب",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBranchDetails() {
    return const Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Iconsax.shop),
              title: Text("فرع الرياض"),
              subtitle: Text("مدة التجهيز: 2 ساعة\nالعنوان: KKKKKKKKKKKKKK"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddress(CheckoutController controller) {
    return Obx(
      () {
        switch (controller.state.value) {
          case CheckoutState.add:
            return _buildAddressForm(controller);
          case CheckoutState.editing:
            return _buildAddressForm(controller);
          case CheckoutState.select:
            return _buildSelectAddress(controller);

          default:
            return _buildAddressForm(controller);
        }
      },
    );
  }

  // Address Form Widget
  Widget _buildAddressForm(CheckoutController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (controller.addresses.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      controller.state.value = CheckoutState.select;
                      controller.clearForm();
                    },
                    icon: Icon(
                      Iconsax.close_circle,
                      size: 32.dm,
                      color: AppColor.emptyColor,
                    ),
                  ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: const Text("إضافة عنوان جديد",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
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
                onPressed: () {
                  controller.saveAddress();
                }, // Save address logic

                child: const Text("حفظ", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectAddress(CheckoutController controller) {
    return Obx(() => Column(
          children: [
            SizedBox(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.addresses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final address = controller.addresses[index];
                  return AddressTile(
                    address: address,
                    onEdit: () => controller.initForm(address),
                    onDelete: () => controller.deleteAddress(address.id),
                    onSelect: () => controller.selectAddress(address),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: controller.addNewAddress,
                child: const Text(
                  "إضافة عنوان جديد",
                ),
              ),
            ),
          ],
        ));
  }
}

// AddressTile widget with radio selection
class AddressTile extends StatelessWidget {
  final Address address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSelect;

  const AddressTile({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<CheckoutController>();
      final isSelected = controller.isSelected(address);
      return GestureDetector(
        onTap: onSelect,
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isSelected
                ? const BorderSide(
                    color: AppColor.primaryColor,
                    width: 1,
                  )
                : BorderSide.none,
          ),
          child: Row(
            children: [
              Radio<String>(
                value: address.id,
                groupValue: controller.selectedAddress.value?.id,
                onChanged: (String? value) => onSelect(),
                activeColor: AppColor.primaryColor,
              ),
              Text(
                "${address.country} - ${address.city} - ${address.street}- ${address.district}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColor.primaryColor : Colors.black,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Iconsax.edit_2),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon:
                        const Icon(Iconsax.trash4, color: AppColor.emptyColor),
                    onPressed: onDelete,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
