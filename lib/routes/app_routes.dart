import 'package:get/get.dart';

import '../futures/shop/screen/home/cart/cart_screen.dart';
import '../futures/shop/screen/home/categories_products_details.dart';
import '../futures/shop/screen/home/home_screen.dart';
import 'routes.dart';

class HAppRoutes {
  static final List<GetPage<dynamic>> pages = [
    GetPage(name: HRoutes.home, page: () => const HomeScreen()),
    GetPage(name: HRoutes.cart, page: () => const CartScreen()),
    GetPage(
        name: HRoutes.categories,
        page: () => const CategoriesProductsDetails()),
  ];
}
