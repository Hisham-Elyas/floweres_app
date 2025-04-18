// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../utils/constants/enums.dart';
import 'address_model.dart';
import 'cart_itme_model.dart';

class OrderModel {
  String? id;
  final String userId;
  final double totalAmount;
  DateTime? createdAt;
  final DeliveryMethod deliveryMethod;
  final Address? shippingAddress;
  final String shippingCompany;
  final String? shippingNotes;
  final String paymentMethod;
  OrderStatus orderStatus;
  final List<CartItemModel> item;

  OrderModel({
    this.id,
    required this.userId,
    required this.totalAmount,
    this.createdAt,
    required this.deliveryMethod,
    required this.shippingAddress,
    required this.shippingCompany,
    this.shippingNotes,
    required this.paymentMethod,
    this.orderStatus = OrderStatus.pending,
    required this.item,
  });

  OrderModel copyWith({
    String? id,
    String? userId,
    double? totalAmount,
    DateTime? createdAt,
    DeliveryMethod? deliveryMethod,
    Address? shippingAddress,
    String? shippingCompany,
    String? shippingNotes,
    String? paymentMethod,
    OrderStatus? orderStatus,
    List<CartItemModel>? item,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      shippingCompany: shippingCompany ?? this.shippingCompany,
      shippingNotes: shippingNotes ?? this.shippingNotes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderStatus: orderStatus ?? this.orderStatus,
      item: item ?? this.item,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id,
      'userId': userId,
      'totalAmount': totalAmount,
      'createdAt': FieldValue.serverTimestamp(), // Always update this field
      'deliveryMethod': deliveryMethod.name.toString(),
      'shippingAddress': shippingAddress?.toMap(),
      'shippingCompany': shippingCompany,
      'shippingNotes': shippingNotes,
      'paymentMethod': paymentMethod,
      'orderStatus': orderStatus.name.toString(),
      'item': item.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      totalAmount: map['totalAmount'] as double,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      deliveryMethod: DeliveryMethod.values
          .byName(map['deliveryMethod'] ?? DeliveryMethod.branchPickup.name),
      shippingAddress: map['shippingAddress'] != null
          ? Address.fromMap(map['shippingAddress'] as Map<String, dynamic>)
          : null,
      shippingCompany: map['shippingCompany'] as String,
      shippingNotes:
          map['shippingNotes'] != null ? map['shippingNotes'] as String : null,
      paymentMethod: map['paymentMethod'] as String,
      // orderStatus: OrderStatus.fromMap(map['orderStatus'] as Map<String,dynamic>),
      orderStatus: OrderStatus.values
          .byName(map['orderStatus'] ?? OrderStatus.pending.name),
      item: List<CartItemModel>.from(
        (map['item'] as List).map<CartItemModel>(
          (x) => CartItemModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory OrderModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return OrderModel(
        id: document.id,
        userId: data['userId'] as String,
        totalAmount: data['totalAmount'] as double,
        createdAt: (data['createdAt'] != null)
            ? (data['createdAt'] as Timestamp).toDate()
            : null,
        deliveryMethod: DeliveryMethod.values
            .byName(data['deliveryMethod'] ?? DeliveryMethod.branchPickup.name),
        shippingAddress: data['shippingAddress'] != null
            ? Address.fromMap(data['shippingAddress'] as Map<String, dynamic>)
            : null,
        shippingCompany: data['shippingCompany'] as String,
        shippingNotes: data['shippingNotes'] != null
            ? data['shippingNotes'] as String
            : null,
        paymentMethod: data['paymentMethod'] as String,
        orderStatus: OrderStatus.values
            .byName(data['orderStatus'] ?? OrderStatus.pending.name),
        item: List<CartItemModel>.from(
          (data['item'] as List).map<CartItemModel>(
            (x) => CartItemModel.fromMap(x as Map<String, dynamic>),
          ),
        ),
      );
    } else {
      return OrderModel.empty();
    }
  }

  static OrderModel empty() => OrderModel(
        id: '',
        userId: '',
        totalAmount: 0,
        deliveryMethod: DeliveryMethod.branchPickup,
        shippingAddress: null,
        shippingCompany: '',
        paymentMethod: '',
        item: [],
      );

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(id: $id, userId: $userId, totalAmount: $totalAmount, createdAt: $createdAt, deliveryMethod: $deliveryMethod, shippingAddress: $shippingAddress, shippingCompany: $shippingCompany, shippingNotes: $shippingNotes, paymentMethod: $paymentMethod, orderStatus: $orderStatus, item: $item)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.totalAmount == totalAmount &&
        other.createdAt == createdAt &&
        other.deliveryMethod == deliveryMethod &&
        other.shippingAddress == shippingAddress &&
        other.shippingCompany == shippingCompany &&
        other.shippingNotes == shippingNotes &&
        other.paymentMethod == paymentMethod &&
        other.orderStatus == orderStatus &&
        listEquals(other.item, item);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        totalAmount.hashCode ^
        createdAt.hashCode ^
        deliveryMethod.hashCode ^
        shippingAddress.hashCode ^
        shippingCompany.hashCode ^
        shippingNotes.hashCode ^
        paymentMethod.hashCode ^
        orderStatus.hashCode ^
        item.hashCode;
  }
}
