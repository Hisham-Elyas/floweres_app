// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {
  String id;
  String name;
  String imageUrl;

  bool isActive;

  double price;
  String detail;
  ProductsModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.isActive = false,
    required this.price,
    required this.detail,
  });

  ProductsModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? imagePath,
    bool? isActive,
    List<String>? categoriesIds,
    double? price,
    String? detail,
  }) {
    return ProductsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      price: price ?? this.price,
      detail: detail ?? this.detail,
    );
  }

  factory ProductsModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return ProductsModel(
        id: document.id,
        name: data['name'] as String,
        imageUrl: data['imageUrl'] as String,
        isActive: data['isActive'] as bool,
        price: (data['price'] as num).toDouble(),
        detail: data['detail'] as String,
      );
    } else {
      return ProductsModel.empty();
    }
  }

  @override
  String toString() {
    return 'ProductsModel(id: $id, name: $name, imageUrl: $imageUrl isActive: $isActive price: $price, detail: $detail)';
  }

  @override
  bool operator ==(covariant ProductsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.isActive == isActive &&
        other.price == price &&
        other.detail == detail;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imageUrl.hashCode ^
        isActive.hashCode ^
        price.hashCode ^
        detail.hashCode;
  }

  static ProductsModel empty() => ProductsModel(
        id: '',
        name: '',
        isActive: false,
        imageUrl: '',
        detail: '',
        price: 0,
      );
  // Convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'price': price,
      'detail': detail,
    };
  }

  // Create a ProductModel from JSON
  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      isActive: json['isActive'] as bool,
      price: (json['price'] as num).toDouble(),
      detail: json['detail'] as String,
    );
  }
}
