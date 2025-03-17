import 'package:get/get.dart';

import '../../../../data/abstract/base_data_controller.dart';
import '../../../../data/repositories/products/products_repo.dart';
import '../../model/products_model.dart';

class ProductsController extends HBaseDataController<ProductsModel> {
  static ProductsController get instance => Get.find();
  final _productsRepo = Get.put(ProductsRepo());

  @override
  Stream<List<ProductsModel>> streamItems() {
    return _productsRepo.getAllProductsStream();
  }

  @override
  bool containsSearchQuery(ProductsModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }
}
