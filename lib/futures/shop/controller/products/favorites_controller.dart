import 'package:get/get.dart';

import '../../../../utils/local_storage/storage_utility.dart';
import '../../model/products_model.dart';

class FavoritesController extends GetxController {
  RxBool isLoading = false.obs;
  final RxList<ProductsModel> favorites = <ProductsModel>[].obs;
  final _storage = HLocalStorage.instance();

  @override
  void onInit() {
    super.onInit();
    loadFavorites(); // Load favorites when controller is initialized
  }

  // Save favorites to GetStorage
  void saveFavorites() {
    List<Map<String, dynamic>> favList =
        favorites.map((product) => product.toJson()).toList();
    _storage.writeData('FAVORITES', favList);
  }

  // Load favorites from GetStorage
  void loadFavorites() {
    isLoading.value = true;
    List<dynamic>? storedFavs = _storage.readData<List<dynamic>>('FAVORITES');
    if (storedFavs != null) {
      favorites
          .assignAll(storedFavs.map((e) => ProductsModel.fromJson(e)).toList());
    }
    isLoading.value = false;
  }

  // Toggle favorite status
  void toggleFavorite(ProductsModel product) {
    if (favorites.contains(product)) {
      favorites.remove(product);
    } else {
      favorites.add(product);
    }
    saveFavorites();
  }

  // Check if a product is in favorites
  bool isFavorite(ProductsModel product) {
    return favorites.contains(product);
  }
}
