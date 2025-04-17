import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../app_coloer.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../controller/cart/checkout_controller.dart';
import '../../../../model/address_model.dart';
import 'confirm_button.dart';

class AddressStep extends StatelessWidget {
  final CheckoutController controller = Get.find<CheckoutController>();

  AddressStep({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = HDeviceUtils.isDesktopScreen(context);
    final isTablet = HDeviceUtils.isTabletScreen(context);

    return Obx(
      () => Card(
        elevation: isDesktop
            ? 4
            : isTablet
                ? 3
                : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HSizes.cardRadiusLg),
        ),
        child: Column(
          children: [
            _buildStepHeader(context),
            if (controller.currentStep.value == 1) _buildAddressContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        child: Text('1', style: TextStyle(fontSize: 16.sp)),
      ),
      title: Text(
        "العنوان",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      trailing: controller.currentStep.value > 1
          ? TextButton(
              onPressed: () => controller.currentStep.value = 1,
              child: Text(
                "تعديل",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColor.primaryColor,
                    ),
              ),
            )
          : null,
    );
  }

  Widget _buildAddressContent() {
    return Padding(
      padding: const EdgeInsets.all(HSizes.defaultSpace),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeliveryMethodSelection(),
            const SizedBox(height: HSizes.spaceBtwSections),
            if (controller.selectedDeliveryMethod.value == 1)
              _buildAddressSelection()
            else
              _buildBranchDetails(),
            if (controller.state.value == CheckoutState.select) ...[
              const SizedBox(height: HSizes.spaceBtwSections),
              ConfirmButton(
                text: "تأكيد العنوان",
                onPressed: () {
                  if (controller.selectedDeliveryMethod.value == 1) {
                    controller.confirmAddress();
                  } else {
                    controller.currentStep.value = 3;
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryMethodSelection() {
    return Obx(
      () => Column(
        children: [
          RadioListTile<int>(
            value: 1,
            activeColor: AppColor.primaryColor,
            groupValue: controller.selectedDeliveryMethod.value,
            onChanged: (value) => _updateDeliveryMethod(value!),
            title: Text("توصيل", style: _radioTextStyle()),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<int>(
            value: 2,
            activeColor: AppColor.primaryColor,
            groupValue: controller.selectedDeliveryMethod.value,
            onChanged: (value) => _updateDeliveryMethod(value!),
            title: Text("إستلام من الفرع", style: _radioTextStyle()),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  TextStyle _radioTextStyle() {
    return const TextStyle(fontWeight: FontWeight.bold);
  }

  void _updateDeliveryMethod(int value) {
    controller.selectedDeliveryMethod.value = value;
    if (value == 2) {
      controller.currentStep.value = 3;
    }
  }

  Widget _buildAddressSelection() {
    return Obx(() {
      switch (controller.state.value) {
        case CheckoutState.add:
        case CheckoutState.editing:
          return AddressForm(controller: controller);
        case CheckoutState.select:
          return _buildSelectAddress();
        default:
          return AddressForm(controller: controller);
      }
    });
  }

  Widget _buildSelectAddress() {
    return Obx(
      () => Column(
        children: [
          if (controller.addresses.isNotEmpty) _buildAddressList(),
          const SizedBox(height: HSizes.spaceBtwItems),
          _buildAddNewAddressButton(),
        ],
      ),
    );
  }

  Widget _buildAddressList() {
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.addresses.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: HSizes.spaceBtwItems),
        itemBuilder: (context, index) {
          final address = controller.addresses[index];
          // final isSelected = controller.isSelected(address);
          return AddressTile(
            address: address,
            // isSelected: isSelected,
            onEdit: () => controller.initForm(address),
            onDelete: () => controller.deleteAddress(address.id),
            onSelect: () => controller.selectAddress(address),
          );
        },
      ),
    );
  }

  Widget _buildAddNewAddressButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Iconsax.add),
        label: const Text("إضافة عنوان جديد"),
        onPressed: controller.addNewAddress,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: HSizes.md),
        ),
      ),
    );
  }

  Widget _buildBranchDetails() {
    return Card(
      elevation: 0,
      color: AppColor.primaryColor.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HSizes.cardRadiusMd),
        side: BorderSide(color: AppColor.primaryColor.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(HSizes.defaultSpace),
        child: Column(
          children: [
            Icon(Iconsax.shop, size: 40.sp, color: AppColor.primaryColor),
            const SizedBox(height: HSizes.md),
            Text('فرع الرياض الرئيسي', style: _branchTextStyle()),
            Text('حي الملز، شارع الملك فهد', style: _branchTextStyle()),
            const SizedBox(height: HSizes.sm),
            Text('رقم الجوال: 0501234567', style: _branchTextStyle()),
            Text('مواعيد العمل: 9 صباحاً - 10 مساءً',
                style: _branchTextStyle()),
          ],
        ),
      ),
    );
  }

  TextStyle _branchTextStyle() {
    return TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);
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
    final isDesktop = HDeviceUtils.isDesktopScreen(context);
    final controller = Get.find<CheckoutController>();

    return Obx(
      () => GestureDetector(
        onTap: onSelect,
        child: Card(
          elevation: 1,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HSizes.cardRadiusSm),
            side: controller.isSelected(address)
                ? const BorderSide(color: AppColor.primaryColor, width: 1.5)
                : BorderSide.none,
          ),
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? HSizes.md : HSizes.sm),
            child: Row(
              children: [
                _buildAddressRadio(controller),
                const SizedBox(width: HSizes.sm),
                _buildAddressText(controller.isSelected(address), context),
                const Spacer(),
                _buildActionButtons(isDesktop),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressRadio(CheckoutController controller) {
    return Radio<String>(
      value: address.id,
      groupValue: controller.selectedAddress.value?.id,
      onChanged: (String? value) => onSelect(),
      activeColor: AppColor.primaryColor,
    );
  }

  Widget _buildAddressText(bool isSelected, BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${address.country} - ${address.city}",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColor.primaryColor : null,
                ),
          ),
          const SizedBox(height: HSizes.xs),
          Text(
            "${address.street} - ${address.district}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDesktop) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Iconsax.edit_2, size: isDesktop ? 24.sp : 20.sp),
          onPressed: onEdit,
        ),
        IconButton(
          icon: Icon(Iconsax.trash,
              size: isDesktop ? 24.sp : 20.sp, color: AppColor.emptyColor),
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class AddressForm extends StatelessWidget {
  final CheckoutController controller;

  const AddressForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDesktop = HDeviceUtils.isDesktopScreen(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HSizes.cardRadiusMd),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? HSizes.defaultSpace : HSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: HSizes.spaceBtwItems),
            _buildDropdowns(),
            const SizedBox(height: HSizes.spaceBtwItems),
            _buildTextFields(),
            const SizedBox(height: HSizes.spaceBtwSections),
            ConfirmButton(
              onPressed: controller.saveAddress,
              text: "حفظ العنوان",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final hasAddresses = Get.find<CheckoutController>().addresses.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (hasAddresses)
          IconButton(
            onPressed: () {
              Get.find<CheckoutController>().state.value = CheckoutState.select;
              Get.find<CheckoutController>().clearForm();
            },
            icon: const Icon(Iconsax.close_circle, color: AppColor.emptyColor),
          ),
        const Spacer(),
        Text(
          "إضافة عنوان جديد",
          style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildDropdowns() {
    return Column(
      children: [
        _buildCountryDropdown(),
        const SizedBox(height: HSizes.spaceBtwInputFields),
        _buildCityDropdown(),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedCountry.value,
        items: ["السعودية"].map(_buildDropdownItem).toList(),
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
        items: ["الرياض", "جدة", "الدمام"].map(_buildDropdownItem).toList(),
        onChanged: (value) => controller.selectedCity.value = value!,
        decoration: const InputDecoration(
          labelText: "اختر المدينة",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String value) {
    return DropdownMenuItem(
      value: value,
      child: Text(value),
    );
  }

  Widget _buildTextFields() {
    return Form(
      key: controller.addressFormKey,
      child: Column(
        children: [
          _buildTextField(controller.streetController, "اسم الشارع"),
          const SizedBox(height: HSizes.spaceBtwInputFields),
          _buildTextField(controller.districtController, "اسم الحي"),
          const SizedBox(height: HSizes.spaceBtwInputFields),
          _buildTextField(controller.houseDescController, "وصف البيت"),
          const SizedBox(height: HSizes.spaceBtwInputFields),
          _buildTextField(controller.postalCodeController, "الرمز البريدي"),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      validator: (value) => HValidator.validateEmptyText(label, value),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
