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

/// Controller responsible for handling checkout process flow
class CheckoutController extends GetxController {
  /// Key for validating address form
  final addressFormKey = GlobalKey<FormState>();

  /// Key for validating payment methods form
  final paymentMethodsFormKey = GlobalKey<FormState>();

  /// Local storage instance for saving/retrieving addresses
  final _storage = HLocalStorage.instance();

  /// Current step in the checkout process (1: Address, 2: Shipping, 3: Payment)
  final RxInt currentStep = 1.obs;

  /// Address form controllers and fields
  final selectedCountry = "السعودية".obs;
  final selectedCity = "الرياض".obs;
  final streetController = TextEditingController();
  final districtController = TextEditingController();
  final houseDescController = TextEditingController();
  final postalCodeController = TextEditingController();

  /// Payment form controllers
  final TextEditingController cvcController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();

  /// List of user saved addresses
  final RxList<Address> addresses = <Address>[].obs;

  /// Currently selected address for delivery
  final Rx<Address?> selectedAddress = Rx<Address?>(null);

  /// Current state of the checkout form (adding, editing, or selecting address)
  final Rx<CheckoutState> state = CheckoutState.add.obs;

  /// Flag indicating if user is editing an existing address
  final RxBool isEditing = false.obs;

  /// Address being edited currently
  Address? editingAddress;

  /// Selected delivery method (1: Home Delivery, 2: Branch Pickup)
  final selectedDeliveryMethod = 1.obs;

  /// Selected payment method (e.g., 'mada')
  final selectedPaymentMethod = 'mada'.obs;

  /// Selected shipping company for delivery
  final selectedShippingCompany = ''.obs;

  /// Notes for shipping/delivery
  final shippingNotesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Load saved addresses from local storage
    loadAddresses();
    // If addresses exist, default to select mode
    if (addresses.isNotEmpty) {
      state.value = CheckoutState.select;
    }
  }

  /// Determines if shipping step should be shown based on delivery method
  bool get showShippingStep => selectedDeliveryMethod.value == 1;

  /// Loads saved addresses from local storage
  void loadAddresses() {
    final storedAddresses = _storage.readData<List<dynamic>>('ADDRESSES');
    if (storedAddresses != null) {
      addresses.assignAll(
        storedAddresses.map((json) => Address.fromMap(json)).toList(),
      );
    }
  }

  /// Saves addresses to local storage
  void saveAddresses() {
    final addressJson = addresses.map((item) => item.toMap()).toList();
    _storage.writeData('ADDRESSES', addressJson);
  }

  /// Sets an address as the selected one
  void selectAddress(Address address) {
    selectedAddress.value = address;
  }

  /// Checks if an address is the currently selected one
  bool isSelected(Address address) => selectedAddress.value?.id == address.id;

  /// Switches to add address mode and clears form
  void addNewAddress() {
    state.value = CheckoutState.add;
    clearForm();
  }

  /// Initializes form with existing address data for editing
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

  /// Saves or updates address based on form data
  void saveAddress() {
    if (!addressFormKey.currentState!.validate()) {
      HLoaders.errorSnackBar(
        title: '❌ خطأ',
        message: 'يرجى ملء جميع الحقول المطلوبة بشكل صحيح 📝',
      );
      return;
    }
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
    HLoaders.successSnackBar(
      title: '✅ تم الحفظ',
      message: 'تم حفظ العنوان بنجاح 🏠',
    );
  }

  /// Deletes an address by ID
  void deleteAddress(String id) {
    addresses.removeWhere((a) => a.id == id);
    HLoaders.successSnackBar(
      title: '🗑️ تم الحذف',
      message: 'تم حذف العنوان بنجاح ✂️',
    );
    if (addresses.isEmpty) state.value = CheckoutState.add;
  }

  /// Clears all form fields and resets editing state
  void clearForm() {
    streetController.clear();
    districtController.clear();
    houseDescController.clear();
    postalCodeController.clear();
    isEditing.value = false;
    editingAddress = null;
  }

  /// Validates the address step before proceeding
  bool validateAddressStep() {
    if (selectedDeliveryMethod.value == 1 && selectedAddress.value == null) {
      HLoaders.errorSnackBar(
        title: '❌ خطأ',
        message: 'يرجى اختيار عنوان أولاً 📍',
      );
      return false;
    }
    return true;
  }

  /// Validates the shipping step before proceeding
  bool validateShippingStep() {
    if (selectedShippingCompany.value.isEmpty) {
      HLoaders.errorSnackBar(
        title: '❌ خطأ',
        message: 'يرجى اختيار شركة شحن 🚚',
      );
      return false;
    }
    return true;
  }

  /// Validates the payment step before proceeding
  bool validatePaymentStep() {
    if (selectedPaymentMethod.value.isEmpty) {
      HLoaders.errorSnackBar(
        title: '❌ خطأ',
        message: 'يرجى اختيار طريقة دفع 💳',
      );
      return false;
    }
    return true;
  }

  /// Confirms address and moves to next step if valid
  void confirmAddress() {
    if (validateAddressStep()) {
      currentStep.value = 2;
    }
  }

  /// Confirms shipping and moves to next step if valid
  void confirmShipping() {
    if (validateShippingStep()) {
      currentStep.value = 3;
    }
  }

  /// Confirms payment and finalizes order if valid
  void confirmPayment() {
    if (validatePaymentStep()) {
      confirmOrder();
    }
  }

  /// Creates and submits the final order
  void confirmOrder() async {
    // Validate address is selected for home delivery
    if (selectedDeliveryMethod.value == 1 && selectedAddress.value == null) {
      HLoaders.errorSnackBar(
        title: '❌ خطأ',
        message: 'يرجى اختيار عنوان أولاً 📍',
      );
      currentStep.value = 1;
      return;
    }

    // Validate shipping company is selected for home delivery
    if (selectedDeliveryMethod.value == 1 &&
        selectedShippingCompany.value.isEmpty) {
      HLoaders.errorSnackBar(
        title: '❌ خطأ',
        message: 'يرجى اختيار شركة شحن 🚚',
      );
      currentStep.value = 2;
      return;
    }

    // Validate payment form
    if (!paymentMethodsFormKey.currentState!.validate()) {
      HLoaders.errorSnackBar(
        title: '❌ خطأ',
        message: 'يرجى ملء جميع الحقول المطلوبة بشكل صحيح 📝',
      );
      return;
    }

    // Show loading indicator
    HFullScreenLoader.popUpCircular();
    final cartController = CartController.instance;

    // Create order model with all data
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
      // Submit order to repository
      await Get.put(OrderRepo()).createOrder(order: order);
      cartController.clearCart();
      HFullScreenLoader.stopLoading();
      Get.offAllNamed(HRoutes.home);
      HLoaders.successSnackBar(
        title: "🎉 تم التأكيد",
        message: "تم تأكيد الطلب بنجاح 🛒",
      );
    } catch (e) {
      HFullScreenLoader.stopLoading();
      HLoaders.errorSnackBar(
        title: "❌ خطأ",
        message: "حدث خطأ أثناء تأكيد الطلب: ${e.toString()}",
      );
    }
  }
}

/// Enum representing different states of the checkout process
enum CheckoutState { add, editing, select }
