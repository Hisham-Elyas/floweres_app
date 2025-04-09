import 'package:get/get.dart';

import '../../../data/repositories/auth/auth_repo.dart';
import '../../../data/repositories/auth/user_repo.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/bottom_sheet.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../shop/model/user_model.dart';
import '../widget/login_widget.dart';
import '../widget/profile_content.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final isLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final RxInt selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void logout() {
    // Add your logout logic here
    Get.offAllNamed('/login');
  }

  @override
  void onInit() {
    loadUserInfo();
    super.onInit();
  }

  openProfile() async {
    if (AuthRepo.instance.isAuthenticated) {
      ///  open Profile
      HBottomSheet.openBottomSheet(child: const ProfileContent());
    } else {
      ///  open Login
      HBottomSheet.openBottomSheet(
        isScrollControlled: true,
        child: const LoginWidget(),
      );
    }
  }

  loadUserInfo() {
    final userRepo = Get.put(UserRepo());
    UserModel? saveUser = userRepo.loadUserInfo();
    if (saveUser == null) {
      _fetchUserDetails();
    } else {
      user.value = saveUser;
    }
  }

  Future<void> updateProfile() async {
    try {
      HFullScreenLoader.popUpCircular();
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        HFullScreenLoader.stopLoading();
        HLoaders.warningSnackBar(title: 'No Internet Connection');
        return;
      }

      // Update user in Firestore
      await UserRepo.instance.updateUser(user: user.value);

      // Update local storage
      UserRepo.instance.saveUserInfo(user: user.value);

      HFullScreenLoader.stopLoading();
      Get.back();
      HLoaders.successSnackBar(title: 'Profile Updated Successfully');
    } catch (e) {
      HFullScreenLoader.stopLoading();
      HLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  _fetchUserDetails() async {
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
      // HLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  signOut() async {
    try {
      await AuthRepo.instance.signOut();
      final userRepo = Get.put(UserRepo());
      userRepo.removeUserInfo();
      Get.back();
    } catch (e) {
      HLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
