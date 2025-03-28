import 'package:floweres_app/futures/shop/model/products_model.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/auth/auth_repo.dart';
import '../../../../utils/local_storage/storage_utility.dart';
import '../../../../utils/popups/bottom_sheet.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../auth/widget/login_widget.dart';
import '../../model/cart_itme_model.dart';
import '../../screen/home/cart/checkout_screen.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final _storage = HLocalStorage.instance();

  String get totalAmountcartItems {
    return cartItems
        .fold(
            0.0,
            (previousValue, element) =>
                previousValue + double.parse(element.totalAmount))
        .toStringAsFixed(2);
  }

  void removeFromCart(String id) {
    cartItems.removeWhere((item) => item.productId == id);
    saveCart(); // Save cart after removing an item
  }

  void decrementQuantity(String id) {
    int index = cartItems.indexWhere((item) => item.productId == id);
    if (index != -1 && cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh(); // Refresh the list to update UI
      saveCart(); // Save updated cart to local storage
    }
  }

  void incrementQuantity(String id) {
    int index = cartItems.indexWhere((item) => item.productId == id);
    if (index != -1 && cartItems[index].quantity < 10) {
      cartItems[index].quantity++;
      cartItems.refresh(); // Refresh the list to update UI
      saveCart(); // Save updated cart to local storage
    }
  }

  void addItemToCart({required ProductsModel product}) {
    int index = cartItems.indexWhere((item) => item.productId == product.id);

    if (index != -1) {
      // If the item is already in the cart, increase its quantity (max 10)
      if (cartItems[index].quantity < 10) {
        cartItems[index].quantity++;
        cartItems.refresh(); // Refresh GetX state
      }
    } else {
      // If the item is not in the cart, add it
      final cartItem = CartItemModel(
        productId: product.id,
        quantity: 1,
        price: product.price,
        productImageUrl: product.imageUrl,
        productName: product.name,
      );
      cartItems.add(cartItem);
    }

    HLoaders.hideSnackBar();
    Get.closeAllSnackbars();
    saveCart(); // Save updated cart

    HLoaders.successSnackBar(title: "Cart", message: "Item Added to Cart ✅");
  }

  @override
  void onInit() {
    loadCart();
    super.onInit();
  }

  void saveCart() {
    List<Map<String, dynamic>> cartJson =
        cartItems.map((item) => item.toMap()).toList();
    _storage.writeData('CART', cartJson);
  }

  void loadCart() {
    List<dynamic>? storedCart = _storage.readData<List<dynamic>>('CART');
    if (storedCart != null) {
      cartItems.assignAll(
          storedCart.map((json) => CartItemModel.fromMap(json)).toList());
    }
  }

  goToCheckoutScreen() async {
    if (AuthRepo.instance.isAuthenticated) {
      Get.to(() => CheckoutScreen());
    } else {
      ///  open Login
      HBottomSheet.openBottomSheet(
        isScrollControlled: true,
        child: const LoginWidget(),
      );
      Get.snackbar(
        "❌ تسجيل الدخول",
        "قم بتسجيل الدخول اولا",
      );
    }
  }
}
