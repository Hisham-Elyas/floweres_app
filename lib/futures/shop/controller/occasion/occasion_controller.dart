import 'package:get/get.dart';

import '../../../../data/abstract/base_data_controller.dart';
import '../../../../data/repositories/occasions/occasions_repo.dart';
import '../../model/occasions_model.dart';

class OccasionController extends HBaseDataController<OccasionsModel> {
  static OccasionController get instance => Get.find();
  final _occasionsRepoRepo = Get.put(OccasionsRepo());

  @override
  Stream<List<OccasionsModel>> streamItems() {
    return _occasionsRepoRepo.getAllOccasionsStream();
  }

  @override
  bool containsSearchQuery(OccasionsModel item, String query) {
    throw UnimplementedError();
  }
}
