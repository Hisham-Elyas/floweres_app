import 'dart:developer';

import 'package:get/get.dart';

import '../../utils/popups/loaders.dart';

abstract class HBaseDataController<T> extends GetxController {
  RxBool isLoading = true.obs;
  RxList<T> allItems = <T>[].obs;
  RxList<T> filteredItems = <T>[].obs;

  Stream<List<T>> streamItems(); // Abstract method for Firestore stream
  bool containsSearchQuery(T item, String query);

  @override
  void onInit() {
    listenToData();
    super.onInit();
  }

  void listenToData() {
    try {
      isLoading.value = true;
      streamItems().listen((List<T> newItems) {
        allItems.assignAll(newItems);
        filteredItems.assignAll(newItems);
      });
    } catch (e) {
      HLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
      log("============================");
      log(e.toString());
      log("============================");
    } finally {
      isLoading.value = false;
    }
  }

  void searchQuery(String query) {
    filteredItems
        .assignAll(allItems.where((item) => containsSearchQuery(item, query)));
    filteredItems.refresh();
  }
}
