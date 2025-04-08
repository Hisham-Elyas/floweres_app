import 'package:floweres_app/data/repositories/order/order_repo.dart';
import 'package:get/get.dart';

import '../../model/order_model.dart';

class OrdersController extends GetxController {
  static OrdersController get instance => Get.find();

  final OrderRepo _orderRepo = Get.put(OrderRepo());
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchUserOrders();
    super.onInit();
  }

  Future<void> fetchUserOrders() async {
    try {
      isLoading.value = true;
      _orderRepo.getAllOrderStream().listen((ordersList) {
        orders.assignAll(ordersList);
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
