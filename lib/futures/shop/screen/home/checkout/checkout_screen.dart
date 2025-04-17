import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app_coloer.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/responsive/responsive_design.dart';
import '../../../../auth/controller/profile_controller.dart';
import '../../../controller/cart/cart_controller.dart';
import '../../../controller/cart/checkout_controller.dart';
import 'widget/address_step.dart';
import 'widget/confirm_button.dart';
import 'widget/payment_step.dart';
import 'widget/shipping_step.dart';

class CheckoutScreen extends StatelessWidget {
  final CheckoutController controller = Get.put(CheckoutController());

  CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "إتمام الطلب",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: HResponsiveWidget(
        desktop: _DesktopCheckoutContent(controller: controller),
        tablet: _TabletCheckoutContent(controller: controller),
        mobile: _MobileCheckoutContent(controller: controller),
      ),
    );
  }
}

// Desktop Layout
class _DesktopCheckoutContent extends StatelessWidget {
  final CheckoutController controller;

  const _DesktopCheckoutContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HSizes.defaultSpace * 2,
        vertical: HSizes.defaultSpace,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Order Summary
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildWelcomeSection(true),
                  const SizedBox(height: HSizes.spaceBtwSections),
                  _buildOrderTotalCard(true),
                ],
              ),
            ),
          ),

          const SizedBox(width: HSizes.spaceBtwSections),

          // Right side - Checkout Steps
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  children: [
                    // Address Step
                    AddressStep(),

                    // Shipping Step (Only for home delivery)
                    if (controller.showShippingStep)
                      const SizedBox(height: HSizes.spaceBtwItems),
                    if (controller.showShippingStep) ShippingStep(),

                    // Payment Step
                    const SizedBox(height: HSizes.spaceBtwItems),
                    PaymentStep(),

                    // Confirm Order Button
                    const SizedBox(height: HSizes.spaceBtwSections),
                    ConfirmButton(
                      onPressed: controller.confirmOrder,
                      text: "تأكيد الطلب",
                      isDesktop: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tablet Layout
class _TabletCheckoutContent extends StatelessWidget {
  final CheckoutController controller;

  const _TabletCheckoutContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(HSizes.defaultSpace),
      child: Column(
        children: [
          _buildWelcomeSection(false),
          const SizedBox(height: HSizes.spaceBtwSections),
          _buildOrderTotalCard(false),
          const SizedBox(height: HSizes.spaceBtwSections),

          // Checkout Steps
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: HSizes.defaultSpace),
            child: Obx(
              () => Column(
                children: [
                  // Address Step
                  AddressStep(),

                  // Shipping Step (Only for home delivery)
                  if (controller.showShippingStep)
                    const SizedBox(height: HSizes.spaceBtwItems),
                  if (controller.showShippingStep) ShippingStep(),

                  // Payment Step
                  const SizedBox(height: HSizes.spaceBtwItems),
                  PaymentStep(),

                  // Confirm Order Button
                  const SizedBox(height: HSizes.spaceBtwSections),
                  ConfirmButton(
                    onPressed: controller.confirmOrder,
                    text: "تأكيد الطلب",
                    isDesktop: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Mobile Layout
class _MobileCheckoutContent extends StatelessWidget {
  final CheckoutController controller;

  const _MobileCheckoutContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(HSizes.sm),
      child: Column(
        children: [
          _buildWelcomeSection(false),
          const SizedBox(height: HSizes.spaceBtwItems),
          _buildOrderTotalCard(false),
          const SizedBox(height: HSizes.spaceBtwSections),

          // Checkout Steps
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HSizes.sm),
            child: Obx(
              () => Column(
                children: [
                  // Address Step
                  AddressStep(),

                  // Shipping Step (Only for home delivery)
                  if (controller.showShippingStep)
                    const SizedBox(height: HSizes.spaceBtwItems),
                  if (controller.showShippingStep) ShippingStep(),

                  // Payment Step
                  const SizedBox(height: HSizes.spaceBtwItems),
                  PaymentStep(),

                  // Confirm Order Button
                  const SizedBox(height: HSizes.spaceBtwSections),
                  ConfirmButton(
                    onPressed: controller.confirmOrder,
                    text: "تأكيد الطلب",
                    isDesktop: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Shared Widgets
Widget _buildWelcomeSection(bool isDesktop) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: isDesktop ? 0 : HSizes.defaultSpace,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          Get.put(ProfileController()).user.value.fullName,
          style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: HSizes.sm),
        Text(
          "مرحباً بك",
          style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    ),
  );
}

Widget _buildOrderTotalCard(bool isDesktop) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: isDesktop ? 0 : HSizes.defaultSpace,
    ),
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HSizes.cardRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(HSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "SAR ${CartController.instance.totalAmountcartItems}",
                  style:
                      Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                ),
                Text(
                  "إجمالي الطلب",
                  style:
                      Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
