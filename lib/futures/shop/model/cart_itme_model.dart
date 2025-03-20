class CartItmeModel {
  String productId;
  String productName;
  String productImageUrl;
  double price;
  int quantity;
  CartItmeModel({
    required this.productId,
    this.productName = '',
    this.productImageUrl = '',
    this.price = 0.0,
    required this.quantity,
  });
  String get totalAmount => (price * quantity).toStringAsFixed(2);

  CartItmeModel copyWith({
    String? productId,
    String? productName,
    String? productImageUrl,
    double? price,
    int? quantity,
  }) {
    return CartItmeModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'productName': productName,
      'productImageUrl': productImageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItmeModel.fromMap(Map<String, dynamic> map) {
    return CartItmeModel(
      productId: map['productId'] as String,
      productName: map['productName'] as String,
      productImageUrl: map['productImageUrl'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
    );
  }

  @override
  String toString() {
    return 'CartItmeModel(productId: $productId, productName: $productName, productImageUrl: $productImageUrl, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant CartItmeModel other) {
    if (identical(this, other)) return true;

    return other.productId == productId &&
        other.productName == productName &&
        other.productImageUrl == productImageUrl &&
        other.price == price &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        productName.hashCode ^
        productImageUrl.hashCode ^
        price.hashCode ^
        quantity.hashCode;
  }
}
