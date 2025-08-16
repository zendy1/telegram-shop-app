class Product {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final List<String> sizes;
  final String imageUrl;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.sizes,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      sizes: List<String>.from(json['sizes'] ?? []),
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'sizes': sizes,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
