import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/order/order_repo.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/local_storage/storage_utility.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../auth/controller/profile_controller.dart';
import '../../model/address_model.dart';
import '../../model/order_model.dart';
import 'cart_controller.dart';

class CheckoutController extends GetxController {
  final _storage = HLocalStorage.instance();

  // Step management
  final RxInt currentStep = 1.obs;

  // Address form controllers
  final selectedCountry = "السعودية".obs;
  final selectedCity = "الرياض".obs;
  final streetController = TextEditingController();
  final districtController = TextEditingController();
  final houseDescController = TextEditingController();
  final postalCodeController = TextEditingController();

  // Address management
  final RxList<Address> addresses = <Address>[].obs;
  final Rx<Address?> selectedAddress = Rx<Address?>(null);

  // Checkout state
  final Rx<CheckoutState> state = CheckoutState.add.obs;
  final RxBool isEditing = false.obs;
  Address? editingAddress;

  // Delivery and payment
  final selectedDeliveryMethod = 1.obs; // 1: Home Delivery, 2: Branch Pickup
  final selectedPaymentMethod = 'mada'.obs;
  final selectedShippingCompany = ''.obs;
  final shippingNotesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
    if (addresses.isNotEmpty) {
      state.value = CheckoutState.select;
    }
  }

  bool get showShippingStep => selectedDeliveryMethod.value == 1;

  // Address methods
  void loadAddresses() {
    final storedAddresses = _storage.readData<List<dynamic>>('ADDRESSES');
    if (storedAddresses != null) {
      addresses.assignAll(
        storedAddresses.map((json) => Address.fromMap(json)).toList(),
      );
    }
  }

  void saveAddresses() {
    final addressJson = addresses.map((item) => item.toMap()).toList();
    _storage.writeData('ADDRESSES', addressJson);
  }

  void selectAddress(Address address) {
    selectedAddress.value = address;
  }

  bool isSelected(Address address) => selectedAddress.value?.id == address.id;

  void addNewAddress() {
    state.value = CheckoutState.add;
    clearForm();
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
      isEditing.value = true;
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
      if (index != -1) addresses[index] = address;
    } else {
      addresses.add(address);
    }

    clearForm();
    state.value = CheckoutState.select;
    saveAddresses();
    Get.snackbar('تم الحفظ', 'تم حفظ العنوان بنجاح');
  }

  void deleteAddress(String id) {
    addresses.removeWhere((a) => a.id == id);
    Get.snackbar('تم الحذف', 'تم حذف العنوان بنجاح');
    if (addresses.isEmpty) state.value = CheckoutState.add;
  }

  void clearForm() {
    streetController.clear();
    districtController.clear();
    houseDescController.clear();
    postalCodeController.clear();
    isEditing.value = false;
    editingAddress = null;
  }

  // Validation and confirmation methods
  bool validateAddressStep() {
    if (selectedDeliveryMethod.value == 1 && selectedAddress.value == null) {
      Get.snackbar('خطأ', 'يرجى اختيار عنوان أولاً');
      return false;
    }
    return true;
  }

  bool validateShippingStep() {
    if (selectedShippingCompany.value.isEmpty) {
      Get.snackbar("خطأ", "يرجى اختيار شركة شحن");
      return false;
    }
    return true;
  }

  bool validatePaymentStep() {
    if (selectedPaymentMethod.value.isEmpty) {
      Get.snackbar("خطأ", "يرجى اختيار طريقة دفع");
      return false;
    }
    return true;
  }

  void confirmAddress() {
    if (validateAddressStep()) {
      currentStep.value = 2;
    }
  }

  void confirmShipping() {
    if (validateShippingStep()) {
      currentStep.value = 3;
    }
  }

  void confirmPayment() {
    if (validatePaymentStep()) {
      confirmOrder();
    }
  }

  void confirmOrder() async {
    if (selectedDeliveryMethod.value == 1 && selectedAddress.value == null) {
      Get.snackbar('خطأ', 'يرجى اختيار عنوان أولاً');
      currentStep.value = 1;
      return;
    }

    if (selectedDeliveryMethod.value == 1 &&
        selectedShippingCompany.value.isEmpty) {
      Get.snackbar("خطأ", "يرجى اختيار شركة شحن");
      currentStep.value = 2;
      return;
    }

    HFullScreenLoader.popUpCircular();
    final cartController = CartController.instance;
    final order = OrderModel(
      userId: ProfileController.instance.user.value.id!,
      totalAmount: double.parse(cartController.totalAmountcartItems),
      shippingNotes: shippingNotesController.text,
      deliveryMethod: selectedDeliveryMethod.value == 1
          ? DeliveryMethod.homeDelivery
          : DeliveryMethod.branchPickup,
      shippingAddress: selectedAddress.value,
      shippingCompany: selectedShippingCompany.value,
      paymentMethod: selectedPaymentMethod.value,
      item: cartController.cartItems,
    );

    try {
      await Get.put(OrderRepo()).createOrder(order: order);
      cartController.clearCart();
      HFullScreenLoader.stopLoading();
      Get.offAllNamed(HRoutes.home);
      Get.snackbar("تم التأكيد", "تم تأكيد الطلب بنجاح");
    } catch (e) {
      HFullScreenLoader.stopLoading();
      HLoaders.errorSnackBar(title: "خطأ", message: e.toString());
    }
  }
}

enum CheckoutState { add, editing, select }
