import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/order/order_repo.dart';
import '../../../../utils/constants/enums.dart';
import '../../model/order_model.dart';

class OrdersController extends GetxController {
  static OrdersController get instance => Get.find();

  final OrderRepo _orderRepo = Get.put(OrderRepo());

  // State variables
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<OrderStatus?> filterStatus = Rx<OrderStatus?>(null);
  final Rx<OrderSortOption> sortBy = OrderSortOption.newest.obs;
  final RxString searchQuery = ''.obs;
  final RxList<String> selectedOrders = <String>[].obs;

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
        filteredOrders;
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  /// Filter and sort orders based on current settings
  List<OrderModel> get filteredOrders {
    List<OrderModel> result = [...orders];

    // Apply status filter
    if (filterStatus.value != null) {
      result = result
          .where((order) => order.orderStatus == filterStatus.value)
          .toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((order) {
        return order.id!.toLowerCase().contains(query) ||
            order.item
                .any((item) => item.productName.toLowerCase().contains(query));
      }).toList();
    }

    // Apply sorting
    switch (sortBy.value) {
      case OrderSortOption.newest:
        result.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        break;
      case OrderSortOption.oldest:
        result.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        break;
      case OrderSortOption.highestAmount:
        result.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
        break;
      case OrderSortOption.lowestAmount:
        result.sort((a, b) => a.totalAmount.compareTo(b.totalAmount));
        break;
    }

    return result;
  }

  /// Set the current filter status
  void setFilterStatus(OrderStatus? status) {
    filterStatus.value = status;
  }

  /// Set the current sort option
  void setSortOption(OrderSortOption option) {
    sortBy.value = option;
  }

  /// Set the search query
  void setSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
  }

  // ADD THIS inside OrdersController:

  final RxString selectedOrderId = ''.obs;
  final ScrollController scrollController = ScrollController();
  final Map<String, GlobalKey> orderItemKeys = {};

  void setSelectedOrderId(String id) {
    selectedOrderId.value = id;

    Future.delayed(const Duration(milliseconds: 300), () {
      final key = orderItemKeys[id];
      final context = key?.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // /// Toggle order selection
  // void toggleOrderSelection(String orderId) {
  //   if (selectedOrders.contains(orderId)) {
  //     selectedOrders.remove(orderId);
  //   } else {
  //     selectedOrders.add(orderId);
  //   }
  // }

  /// Mark selected orders as read
  // Future<void> markSelectedAsRead() async {
  //   try {
  //     isLoading.value = true;
  //     for (final orderId in selectedOrders) {
  //       await _orderRepo.markOrderAsRead(orderId);
  //     }
  //     selectedOrders.clear();
  //     Get.snackbar('Success', 'Orders marked as read');
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // /// Cancel selected orders
  // Future<void> cancelSelectedOrders() async {
  //   try {
  //     isLoading.value = true;
  //     for (final orderId in selectedOrders) {
  //       await _orderRepo.cancelOrder(orderId);
  //     }
  //     selectedOrders.clear();
  //     Get.snackbar('Success', 'Orders cancelled successfully');
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  /// Refresh orders data
  // Future<void> refreshOrders() async {
  //   await fetchUserOrders();
  // }
}

/// Sorting options enum
enum OrderSortOption {
  newest,
  oldest,
  highestAmount,
  lowestAmount,
}
