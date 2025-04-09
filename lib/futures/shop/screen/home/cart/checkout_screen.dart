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
      body: Obx(() => SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildWelcomeSection(),
                SizedBox(height: 10.h),
                _buildOrderTotalCard(),
                SizedBox(height: 20.h),

                // Address Step (Always visible)
                _buildAddressStep(),

                // Shipping Step (Only for home delivery)
                if (controller.showShippingStep) SizedBox(height: 10.h),
                if (controller.showShippingStep) _buildShippingStep(),

                // Payment Step (Always visible)
                SizedBox(height: 10.h),
                _buildPaymentStep(),

                // Confirm Order Button (Always visible)
                SizedBox(height: 20.h),
                _buildConfirmOrderButton(),
              ],
            ),
          )),
    );
  }

  Widget _buildAddressStep() {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColor.primaryColor,
              foregroundColor: Colors.white,
              child: Text('1'),
            ),
            title: const Text(
              "العنوان",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            trailing: controller.currentStep.value > 1
                ? TextButton(
                    onPressed: () => controller.currentStep.value = 1,
                    child: const Text(
                      "تعديل",
                      style: TextStyle(color: AppColor.primaryColor),
                    ),
                  )
                : null,
          ),
          if (controller.currentStep.value == 1) _buildAddressContent(),
        ],
      ),
    );
  }

  Widget _buildShippingStep() {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: controller.currentStep.value >= 2
                  ? AppColor.primaryColor
                  : Colors.grey,
              foregroundColor: Colors.white,
              child: const Text('2'),
            ),
            title: Text(
              "الشحن",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: controller.currentStep.value >= 2
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
            trailing: controller.currentStep.value > 2
                ? TextButton(
                    onPressed: () => controller.currentStep.value = 2,
                    child: const Text(
                      "تعديل",
                      style: TextStyle(color: AppColor.primaryColor),
                    ),
                  )
                : null,
          ),
          if (controller.currentStep.value == 2) _buildShippingContent(),
        ],
      ),
    );
  }

  Widget _buildPaymentStep() {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: controller.currentStep.value >= 3
                  ? AppColor.primaryColor
                  : Colors.grey,
              foregroundColor: Colors.white,
              child: const Text('3'),
            ),
            title: Text(
              "الدفع",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: controller.currentStep.value >= 3
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ),
          if (controller.currentStep.value == 3) _buildPaymentContent(),
        ],
      ),
    );
  }

  Widget _buildAddressContent() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildDeliveryMethodSelection(),
          SizedBox(height: 20.h),
          Obx(() => controller.selectedDeliveryMethod.value == 1
              ? _buildAddressSelection()
              : _buildBranchDetails()),
          SizedBox(height: 20.h),
          _buildConfirmButton(
            text: "تأكيد العنوان",
            onPressed: controller.confirmAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildShippingContent() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildShippingOptions(),
          SizedBox(height: 20.h),
          _buildShippingNotesField(),
          SizedBox(height: 20.h),
          _buildConfirmButton(
            text: "تأكيد الشحن",
            onPressed: controller.confirmShipping,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentContent() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildPaymentMethodButtons(),
          SizedBox(height: 20.h),
          _buildCardDetailsForm(),
          SizedBox(height: 20.h),
          _buildDeliveryNote(),
        ],
      ),
    );
  }

  Widget _buildDeliveryMethodSelection() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: RadioListTile<int>(
              value: 1,
              activeColor: AppColor.primaryColor,
              groupValue: controller.selectedDeliveryMethod.value,
              onChanged: (value) {
                controller.selectedDeliveryMethod.value = value!;
                if (value == 2) {
                  // Skip shipping step if branch pickup selected
                  controller.currentStep.value = 3;
                }
              },
              title: const Text("توصيل"),
            ),
          ),
          Expanded(
            child: RadioListTile<int>(
              value: 2,
              activeColor: AppColor.primaryColor,
              groupValue: controller.selectedDeliveryMethod.value,
              onChanged: (value) {
                controller.selectedDeliveryMethod.value = value!;
                if (value == 2) {
                  // Skip shipping step if branch pickup selected
                  controller.currentStep.value = 3;
                }
              },
              title: const Text("إستلام من الفرع"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSelection() {
    return Obx(() {
      switch (controller.state.value) {
        case CheckoutState.add:
          return _buildAddressForm();
        case CheckoutState.editing:
          return _buildAddressForm();
        case CheckoutState.select:
          return _buildSelectAddress();
        default:
          return _buildAddressForm();
      }
    });
  }

  Widget _buildAddressForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressFormHeader(),
            SizedBox(height: 10.h),
            _buildCountryDropdown(),
            SizedBox(height: 10.h),
            _buildCityDropdown(),
            SizedBox(height: 10.h),
            _buildStreetField(),
            SizedBox(height: 10.h),
            _buildDistrictField(),
            SizedBox(height: 10.h),
            _buildHouseDescriptionField(),
            SizedBox(height: 10.h),
            _buildPostalCodeField(),
            SizedBox(height: 15.h),
            _buildSaveAddressButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressFormHeader() {
    return Row(
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
              size: 32.sp,
              color: AppColor.emptyColor,
            ),
          ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(right: 15.w),
          child: Text(
            "إضافة عنوان جديد",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedCountry.value,
        items: ["السعودية"]
            .map((country) => DropdownMenuItem(
                  value: country,
                  child: Text(country),
                ))
            .toList(),
        onChanged: (value) => controller.selectedCountry.value = value!,
        decoration: const InputDecoration(
          labelText: "اختر الدولة",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedCity.value,
        items: ["الرياض", "جدة", "الدمام"]
            .map((city) => DropdownMenuItem(
                  value: city,
                  child: Text(city),
                ))
            .toList(),
        onChanged: (value) => controller.selectedCity.value = value!,
        decoration: const InputDecoration(
          labelText: "اختر المدينة",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildStreetField() {
    return TextFormField(
      controller: controller.streetController,
      decoration: const InputDecoration(
        labelText: "اسم الشارع",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDistrictField() {
    return TextFormField(
      controller: controller.districtController,
      decoration: const InputDecoration(
        labelText: "اسم الحي",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildHouseDescriptionField() {
    return TextFormField(
      controller: controller.houseDescController,
      decoration: const InputDecoration(
        labelText: "وصف البيت (اختياري)",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPostalCodeField() {
    return TextFormField(
      controller: controller.postalCodeController,
      decoration: const InputDecoration(
        labelText: "الرمز البريدي",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSaveAddressButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        onPressed: controller.saveAddress,
        child: Text(
          "حفظ العنوان",
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
      ),
    );
  }

  Widget _buildSelectAddress() {
    return Obx(
      () => Column(
        children: [
          SizedBox(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.addresses.length,
              separatorBuilder: (_, __) => SizedBox(height: 8.h),
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
          SizedBox(height: 8.h),
          _buildAddNewAddressButton(),
        ],
      ),
    );
  }

  Widget _buildAddNewAddressButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: controller.addNewAddress,
        child: const Text("إضافة عنوان جديد"),
      ),
    );
  }

  Widget _buildShippingOptions() {
    return Obx(
      () => Column(
        children: [
          RadioListTile<String>(
            title: Text(
              "1 مندوب",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "خلال 24 ساعة",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            secondary: Text(
              "50 ﷼",
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
            ),
            value: "1 مندوب",
            groupValue: controller.selectedShippingCompany.value,
            onChanged: (value) =>
                controller.selectedShippingCompany.value = value!,
            activeColor: AppColor.primaryColor,
          ),
          RadioListTile<String>(
            title: Text(
              "2 مندوب",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "خلال 48 ساعة",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            secondary: Text(
              "25 ﷼",
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
            ),
            value: "2 مندوب",
            groupValue: controller.selectedShippingCompany.value,
            onChanged: (value) =>
                controller.selectedShippingCompany.value = value!,
            activeColor: AppColor.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildShippingNotesField() {
    return TextFormField(
      controller: controller.shippingNotesController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: "أضف ملاحظة",
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildPaymentMethodButtons() {
    return Row(
      children: [
        _buildPaymentMethodButton(
          method: 'mada',
          imagePath: 'assets/images/pay-option-mada.png',
          label: 'مدى',
        ),
        _buildPaymentMethodButton(
          method: 'tabby',
          label: 'تابي',
          imagePath: 'assets/images/pay-option-tabby_en.png',
        ),
        _buildPaymentMethodButton(
          imagePath: 'assets/images/pay-option-credit-2.png',
          method: 'visa',
          label: 'فيزا',
        ),
      ],
    );
  }

  Widget _buildPaymentMethodButton({
    required String method,
    required String imagePath,
    required String label,
  }) {
    return Obx(() {
      final isSelected = controller.selectedPaymentMethod.value == method;
      return Expanded(
        child: GestureDetector(
          onTap: () => controller.selectPaymentMethod(method),
          child: Container(
            padding: EdgeInsets.all(8.w),
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColor.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              border: Border.all(
                color:
                    isSelected ? AppColor.primaryColor : Colors.grey.shade300,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 20.w,
                  height: 24.h,
                  child: Radio<String>(
                    value: method,
                    groupValue: controller.selectedPaymentMethod.value,
                    onChanged: (value) =>
                        controller.selectPaymentMethod(value!),
                    activeColor: AppColor.primaryColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                SizedBox(width: 4.w),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      imagePath,
                      width: 40.w,
                      height: 24.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColor.primaryColor
                            : Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCardDetailsForm() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: "رقم البطاقة",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Iconsax.card),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "تاريخ الانتهاء",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.calendar_1),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "CVC",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.lock_1),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeliveryNote() {
    return Text(
      "ملاحظة: لا يمكن توصيل الطلب في نفس اليوم عند إتمام الطلب بعد الساعة 11 ليلاً، ولكن يتم ترحيل التوصيل لليوم التالي. طلبات منطقة جدة ومكة يتم ترحيلها للصباح التالي.",
      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
    );
  }

  Widget _buildConfirmButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
      ),
    );
  }

  Widget _buildConfirmOrderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        onPressed: controller.confirmOrder,
        child: Text(
          "تأكيد الطلب",
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Row(
      children: [
        Text(
          Get.put(ProfileController()).user.value.fullName,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10.w),
        Text(
          "مرحباً بك",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildOrderTotalCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
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
                  ),
                ),
                Text(
                  "إجمالي الطلب",
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchDetails() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.shop),
          SizedBox(height: 10.h),
          const Text('فرع الرياض الرئيسي'),
          const Text('حي الملز، شارع الملك فهد'),
          const Text('رقم الجوال: 0501234567'),
          const Text('مواعيد العمل: 9 صباحاً - 10 مساءً'),
        ],
      ),
    );
  }
}

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
          margin: EdgeInsets.symmetric(vertical: 4.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: isSelected
                ? const BorderSide(
                    color: AppColor.primaryColor,
                    width: 1.5,
                  )
                : BorderSide.none,
          ),
          child: Row(
            children: [
              _buildAddressRadio(controller),
              _buildAddressText(isSelected),
              const Spacer(),
              _buildActionButtons(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAddressRadio(CheckoutController controller) {
    return Radio<String>(
      value: address.id,
      groupValue: controller.selectedAddress.value?.id,
      onChanged: (String? value) => onSelect(),
      activeColor: AppColor.primaryColor,
    );
  }

  Widget _buildAddressText(bool isSelected) {
    return Text(
      "${address.country} - ${address.city} - ${address.street}- ${address.district}",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: isSelected ? AppColor.primaryColor : Colors.black,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Iconsax.edit_2),
          onPressed: onEdit,
        ),
        IconButton(
          icon: const Icon(Iconsax.trash4, color: AppColor.emptyColor),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
