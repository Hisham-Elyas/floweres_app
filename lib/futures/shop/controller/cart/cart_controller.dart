import 'package:floweres_app/futures/shop/model/products_model.dart';
import 'package:get/get.dart';

import '../../../../utils/popups/loaders.dart';
import '../../model/cart_itme_model.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();
  final RxList<CartItmeModel> cartItmes = <CartItmeModel>[].obs;
  void addItmeToCart({required ProductsModel product}) {
    final cartItme = CartItmeModel(
        productId: product.id,
        quantity: 1,
        price: product.price,
        productImageUrl: product.imageUrl,
        productName: product.name);
    if (cartItmes.contains(cartItmes.firstWhere(
      (element) => element.productId == cartItme.productId,
      orElse: () => cartItme,
    ))) {
      final indexItme = cartItmes.indexWhere(
        (element) {
          return element.productId == cartItme.productId;
        },
      );
      if (cartItmes[indexItme].quantity < 10) {
        cartItmes[indexItme].quantity++;
      }
    } else {
      cartItmes.add(cartItme);
    }
    HLoaders.hideSnackBar();
    Get.closeAllSnackbars();
    HLoaders.successSnackBar(title: "Cart", message: "Add Itme To Cart ✅");
  }
}
