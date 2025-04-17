import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../app_coloer.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../controller/cart/checkout_controller.dart';
import 'confirm_button.dart';

class PaymentStep extends StatelessWidget {
  final CheckoutController controller = Get.find<CheckoutController>();

  PaymentStep({super.key});

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
          borderRadius: BorderRadius.circular(HSizes.cardRadiusLg.r),
        ),
        child: Column(
          children: [
            _buildStepHeader(context),
            if (controller.currentStep.value == 3) _buildPaymentContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context) {
    final isActive = controller.currentStep.value >= 3;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isActive ? AppColor.primaryColor : Colors.grey[300],
        foregroundColor: isActive ? Colors.white : Colors.grey[500],
        child: Text(
          '3',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        "الدفع",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.grey,
            ),
      ),
    );
  }

  Widget _buildPaymentContent() {
    return Padding(
      padding: const EdgeInsets.all(HSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "طريقة الدفع",
            style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: HSizes.spaceBtwItems.h),
          _buildPaymentMethodButtons(),
          SizedBox(height: HSizes.spaceBtwSections.h),
          _buildCardDetailsForm(),
          SizedBox(height: HSizes.spaceBtwSections.h),
          _buildDeliveryNote(),
          SizedBox(height: HSizes.spaceBtwSections.h),
          ConfirmButton(
            text: "تأكيد الدفع",
            onPressed: controller.confirmPayment,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodButtons() {
    return Obx(
      () => Row(
        children: [
          _buildPaymentMethodButton(
            method: 'mada',
            imagePath: 'assets/images/pay-option-mada.png',
            label: 'مدى',
            isSelected: controller.selectedPaymentMethod.value == 'mada',
          ),
          const SizedBox(width: HSizes.sm),
          _buildPaymentMethodButton(
            method: 'tabby',
            label: 'تابي',
            imagePath: 'assets/images/pay-option-tabby_en.png',
            isSelected: controller.selectedPaymentMethod.value == 'tabby',
          ),
          const SizedBox(width: HSizes.sm),
          _buildPaymentMethodButton(
            imagePath: 'assets/images/pay-option-credit-2.png',
            method: 'visa',
            label: 'فيزا',
            isSelected: controller.selectedPaymentMethod.value == 'visa',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodButton({
    required String method,
    required String imagePath,
    required String label,
    required bool isSelected,
  }) {
    final isDesktop = HDeviceUtils.isDesktopScreen(Get.context!);

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedPaymentMethod(method),
        child: Container(
          padding: EdgeInsets.all(isDesktop ? HSizes.md : HSizes.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            border: Border.all(
              color: isSelected ? AppColor.primaryColor : Colors.grey[300]!,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(HSizes.borderRadiusMd.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                width: isDesktop ? 60.w : 40.w,
                height: isDesktop ? 36.h : 24.h,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: HSizes.xs),
              Text(
                label,
                style: TextStyle(
                  fontSize: isDesktop ? 16.sp : 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColor.primaryColor : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardDetailsForm() {
    return Form(
      key: controller.paymentMethodsFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تفاصيل البطاقة",
            style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: HSizes.spaceBtwItems),
          TextFormField(
            validator: (value) =>
                HValidator.validateEmptyText("رقم البطاقة", value),
            controller: controller.cardNumberController,
            decoration: const InputDecoration(
              labelText: "رقم البطاقة",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Iconsax.card),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: HSizes.spaceBtwInputFields),
          Row(
            children: [
              // Expiry date field
              Expanded(
                child: TextFormField(
                  validator: (value) =>
                      HValidator.validateEmptyText("تاريخ الانتهاء", value),
                  controller: controller.expiryDateController,
                  decoration: const InputDecoration(
                    labelText: "تاريخ الانتهاء",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Iconsax.calendar_1),
                  ),
                ),
              ),
              const SizedBox(width: HSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  validator: (value) =>
                      HValidator.validateEmptyText("CVC", value),
                  controller: controller.cvcController,
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
      ),
    );
  }

  Widget _buildDeliveryNote() {
    return Container(
      padding: const EdgeInsets.all(HSizes.defaultSpace),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(HSizes.borderRadiusMd.r),
      ),
      child: Text(
        "ملاحظة: لا يمكن توصيل الطلب في نفس اليوم عند إتمام الطلب بعد الساعة 11 ليلاً، ولكن يتم ترحيل التوصيل لليوم التالي. طلبات منطقة جدة ومكة يتم ترحيلها للصباح التالي.",
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 12.sp,
          height: 1.5,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
