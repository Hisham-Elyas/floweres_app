import 'package:floweres_app/utils/constants/sizes.dart';
import 'package:floweres_app/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../app_coloer.dart';
import '../../../../controller/cart/checkout_controller.dart';
import 'confirm_button.dart';

class ShippingStep extends StatelessWidget {
  final CheckoutController controller = Get.find<CheckoutController>();

  ShippingStep({super.key});

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
            if (controller.currentStep.value == 2) _buildShippingContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context) {
    final isActive = controller.currentStep.value >= 2;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isActive ? AppColor.primaryColor : Colors.grey[300],
        foregroundColor: isActive ? Colors.white : Colors.grey[500],
        child: Text(
          '2',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        "الشحن",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.grey,
            ),
      ),
      trailing: controller.currentStep.value > 2
          ? TextButton(
              onPressed: () => controller.currentStep.value = 2,
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

  Widget _buildShippingContent() {
    return Padding(
      padding: const EdgeInsets.all(HSizes.defaultSpace),
      child: Column(
        children: [
          _buildShippingOptions(),
          SizedBox(height: HSizes.spaceBtwSections.h),
          _buildShippingNotesField(),
          SizedBox(height: HSizes.spaceBtwSections.h),
          ConfirmButton(
            text: "تأكيد الشحن",
            onPressed: controller.confirmShipping,
          ),
        ],
      ),
    );
  }

  Widget _buildShippingOptions() {
    return Obx(
      () => Column(
        children: [
          _buildShippingOption(
            title: "1 مندوب",
            subtitle: "خلال 24 ساعة",
            price: "50 ﷼",
            value: "1 مندوب",
            isSelected: controller.selectedShippingCompany.value == "1 مندوب",
          ),
          SizedBox(height: HSizes.spaceBtwItems.h),
          _buildShippingOption(
            title: "2 مندوب",
            subtitle: "خلال 48 ساعة",
            price: "25 ﷼",
            value: "2 مندوب",
            isSelected: controller.selectedShippingCompany.value == "2 مندوب",
          ),
        ],
      ),
    );
  }

  Widget _buildShippingOption({
    required String title,
    required String subtitle,
    required String price,
    required String value,
    required bool isSelected,
  }) {
    return Card(
      elevation: 0,
      color: isSelected
          ? AppColor.primaryColor.withOpacity(0.05)
          : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HSizes.cardRadiusMd),
        side: BorderSide(
          color:
              isSelected ? AppColor.primaryColor : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: RadioListTile<String>(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                // fontSize: isDesktop ? 16.sp : 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: HSizes.xs),
            Text(
              subtitle,
              style: TextStyle(
                // fontSize: isDesktop ? 12.sp : 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        secondary: Text(
          price,
          style: const TextStyle(
            // fontSize: isDesktop ? 18.sp : 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        value: value,
        groupValue: controller.selectedShippingCompany.value,
        onChanged: (value) => controller.selectedShippingCompany.value = value!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HSizes.cardRadiusMd),
        ),
        activeColor: AppColor.primaryColor,
        // contentPadding: const EdgeInsets.symmetric(
        //   horizontal: HSizes.defaultSpace,
        //   vertical: HSizes.sm,
        // ),
      ),
    );
  }

  Widget _buildShippingNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ملاحظات التوصيل (اختياري)",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: HSizes.sm),
        TextFormField(
          controller: controller.shippingNotesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "أضف ملاحظات خاصة بالتوصيل...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HSizes.borderRadiusMd),
            ),
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.all(HSizes.md),
          ),
        ),
      ],
    );
  }
}
