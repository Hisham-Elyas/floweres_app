import 'dart:developer';

import 'package:get/get.dart';

import '../../../../data/repositories/products/products_repo.dart';
import '../../../../utils/popups/loaders.dart';
import '../../model/products_model.dart';

class CategoriesProductsDetailsController extends GetxController {
  RxBool isLoading = true.obs;
  static CategoriesProductsDetailsController get instance => Get.find();
  final RxList<ProductsModel> items = <ProductsModel>[].obs;
  final _productsRepo = Get.put(ProductsRepo());
  Future getProductByCategories({required String categoryId}) async {
    try {
      final newItems = await _productsRepo.getAllProductsByCategories(
          categoryId: categoryId);
      items.assignAll(newItems);
    } catch (e) {
      HLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
      log("============================");
      log(e.toString());
      log("============================");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
