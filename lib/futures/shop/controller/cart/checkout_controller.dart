import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  var couponController = TextEditingController();
  var streetController = TextEditingController();
  var districtController = TextEditingController();
  var houseDescController = TextEditingController();
  var postalCodeController = TextEditingController();

  var selectedCountry = "السعودية".obs;
  var selectedCity = "الرياض".obs;
  var selectedDeliveryMethod = 1.obs; // 1: Home Delivery, 2: Branch Pickup

  /// Fake apply coupon logic
  void applyCoupon() {
    // Add your coupon logic here
    Get.snackbar("Coupon", "تم تطبيق الكوبون بنجاح (مثال)");
  }

  /// Fake confirm order logic
  void confirmOrder() {
    // Add your order confirmation logic here
    Get.snackbar("Order", "تم تأكيد الطلب بنجاح (مثال)");
  }

  /// Save address logic
  void saveAddress() {
    // Save address to user profile or any backend
    Get.snackbar("Address", "تم حفظ العنوان بنجاح (مثال)");
  }
}
