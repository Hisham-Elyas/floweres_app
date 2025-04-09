import 'package:get/get.dart';

import '../../../../data/abstract/base_data_controller.dart';
import '../../../../data/repositories/categories/categories_repo.dart';
import '../../model/category_model.dart';

class CategoriesController extends HBaseDataController<CategoryModel> {
  static CategoriesController get instance => Get.find();
  final _categoriesRepo = Get.put(CategoriesRepo());

  @override
  bool containsSearchQuery(CategoryModel item, String query) {
    throw UnimplementedError();
  }

  @override
  Stream<List<CategoryModel>> streamItems() {
    return _categoriesRepo.getAllcategoriesStream();
  }
}
