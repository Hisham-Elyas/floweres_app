import 'cart_itme_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final double totalAmount;
  final DateTime orderDate;
  final String shippingAddress;
  final String paymentMethod;
  final List<CartItemModel> item;

  OrderModel(
      {required this.id,
      required this.paymentMethod,
      required this.totalAmount,
      required this.userId,
      required this.orderDate,
      required this.shippingAddress,
      required this.item});
}
