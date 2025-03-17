import 'package:get/get.dart';

import '../../../../data/abstract/base_data_controller.dart';
import '../../../../data/repositories/banners/banners_repo.dart';
import '../../model/banners_model.dart';

class BannersController extends HBaseDataController<BannersModel> {
  static BannersController get instance => Get.find();
  RxDouble position = 0.0.obs;
  final _bannersRepoRepo = Get.put(BannersRepo());

  @override
  bool containsSearchQuery(BannersModel item, String query) {
    // TODO: implement containsSearchQuery
    throw UnimplementedError();
  }

  @override
  Stream<List<BannersModel>> streamItems() {
    return _bannersRepoRepo.getAllBannersStream();
  }
}
