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

  void applyCoupon() {
    // Add logic to apply the coupon
  }

  void confirmOrder() {
    // Add logic to confirm the order
  }
}
