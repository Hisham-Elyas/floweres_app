import 'package:get/get.dart';

import '../../../data/repositories/auth/auth_repo.dart';
import '../../../data/repositories/auth/user_repo.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/bottom_sheet.dart';
import '../../../utils/popups/loaders.dart';
import '../../shop/model/user_model.dart';
import '../widget/login_widget.dart';
import '../widget/profile_content.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  final isLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  openProfile() async {
    if (AuthRepo.instance.isAuthenticated) {
      ///  open Profile
      HBottomSheet.openBottomSheet(child: const ProfileContent());
      await fetchUserDetails();
    } else {
      ///  open Login
      HBottomSheet.openBottomSheet(
        isScrollControlled: true,
        child: const LoginWidget(),
      );
    }
  }

  fetchUserDetails() async {
    try {
      isLoading.value = true;
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }
      final userRepo = Get.put(UserRepo());
      user.value = await userRepo.fetchUserDetails();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      HLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  signOut() async {
    try {
      await AuthRepo.instance.signOut();
      Get.back();
    } catch (e) {
      HLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
