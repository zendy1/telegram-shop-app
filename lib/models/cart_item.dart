import '../models/product.dart';

class CartItem {
  final int id;
  final int userId;
  final int productId;
  final String size;
  final int quantity;
  final DateTime createdAt;
  final Product? product;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.size,
    required this.quantity,
    required this.createdAt,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      size: json['size'],
      quantity: json['quantity'],
      createdAt: DateTime.parse(json['created_at']),
      product: json['products'] != null ? Product.fromJson(json['products']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'size': size,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
    };
  }

  double get totalPrice => (product?.price ?? 0) * quantity;
}
