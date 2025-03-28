import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/local_storage/storage_utility.dart';
import '../../model/address_model.dart';

class CheckoutController extends GetxController {
  final _storage = HLocalStorage.instance();
  var couponController = TextEditingController();

  // Form controllers
  var selectedCountry = "السعودية".obs;
  var selectedCity = "الرياض".obs;
  var streetController = TextEditingController();
  var districtController = TextEditingController();
  var houseDescController = TextEditingController();
  var postalCodeController = TextEditingController();

  final RxList<Address> addresses = <Address>[].obs;
  final Rx<Address?> selectedAddress = Rx<Address?>(null);
  final RxString selectedAddressId = ''.obs;
  final Rx<CheckoutState> state = CheckoutState.add.obs;
  final RxBool isEditing = false.obs;
  Address? editingAddress;

  var selectedDeliveryMethod = 1.obs; // 1: Home Delivery, 2: Branch Pickup
  // Add in CheckoutController
  var selectedPaymentMethod = 'mada'.obs;

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // Add to CheckoutController
  final RxString selectedShippingCompany = ''.obs;
  final shippingNotesController = TextEditingController();

  void confirmShipping() {
    if (selectedShippingCompany.isEmpty) {
      Get.snackbar("خطأ", "يرجى اختيار شركة شحن");
      return;
    }
    // Handle shipping confirmation logic
    Get.snackbar("تم التأكيد", "تم تأكيد شركة الشحن بنجاح");
  }

  @override
  void onInit() {
    loadAddresses();
    if (addresses.isNotEmpty) {
      state.value = CheckoutState.select;
    }
    super.onInit();
  }

  void saveAddresses() {
    List<Map<String, dynamic>> cartJson =
        addresses.map((item) => item.toMap()).toList();
    _storage.writeData('ADDRESSES', cartJson);
  }

  void loadAddresses() {
    List<dynamic>? storedAddresses =
        _storage.readData<List<dynamic>>('ADDRESSES');
    if (storedAddresses != null) {
      addresses.assignAll(
          storedAddresses.map((json) => Address.fromMap(json)).toList());
    }
  }

  void selectAddress(Address address) {
    selectedAddress.value = address;
    selectedAddressId.value = address.id;
  }

  bool isSelected(Address address) {
    return selectedAddressId.value == address.id;
  }

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

  addNewAddress() {
    state.value = CheckoutState.add;
  }

  void initForm(Address? address) {
    if (address != null) {
      selectedCountry.value = address.country;
      selectedCity.value = address.city;
      streetController.text = address.street;
      districtController.text = address.district;
      houseDescController.text = address.houseDesc;
      postalCodeController.text = address.postalCode;
      state.value = CheckoutState.editing;
      isEditing.value = false;
      editingAddress = address;
    }
  }

  void saveAddress() {
    final address = Address(
      id: editingAddress?.id ?? DateTime.now().toIso8601String(),
      city: selectedCity.value,
      country: selectedCountry.value,
      district: districtController.text,
      street: streetController.text,
      houseDesc: houseDescController.text,
      postalCode: postalCodeController.text,
    );

    if (isEditing.value) {
      final index = addresses.indexWhere((a) => a.id == address.id);
      addresses[index] = address;
    } else {
      addresses.add(address);
    }

    clearForm();
    state.value = CheckoutState.select;
    saveAddresses();
    Get.snackbar(
      'تم الحفظ',
      'تم حفظ العنوان بنجاح',
    );
  }

  void deleteAddress(String id) {
    addresses.removeWhere((a) => a.id == id);
    Get.snackbar(
      'تم الحذف',
      'تم حذف العنوان بنجاح',
    );
    if (addresses.isEmpty) {
      state.value = CheckoutState.add;
    }
  }

  void clearForm() {
    streetController.clear();
    districtController.clear();
    houseDescController.clear();
    postalCodeController.clear();

    isEditing.value = false;
    editingAddress = null;
  }

  void confirmAddress() {
    if (selectedAddress.value == null) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار عنوان أولاً',
      );
      return;
    }
  }
}

enum CheckoutState { add, editing, select }
