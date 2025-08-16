import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class SupabaseService {
  static const String _url = 'https://xjpnayqoceyvtrubrqam.supabase.co';
  static const String _anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhqcG5heXFvY2V5dnRydWJycWFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyMTM4MzYsImV4cCI6MjA3MDc4OTgzNn0.2K8esBiRW15EWAOpKrY7kaE2Qmv57fYYw-gRAVzZRJI';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _url,
      anonKey: _anonKey,
    );
  }

  // Категории
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await client
        .from('categories')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // Товары по категории
  static Future<List<Map<String, dynamic>>> getProductsByCategory(int categoryId) async {
    final response = await client
        .from('products')
        .select()
        .eq('category_id', categoryId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // Товар по ID
  static Future<Map<String, dynamic>?> getProduct(int productId) async {
    final response = await client
        .from('products')
        .select()
        .eq('id', productId)
        .single();
    return response;
  }

  // Добавить товар в корзину
  static Future<void> addToCart(int userId, int productId, String size, int quantity) async {
    await client.from('cart_items').insert({
      'user_id': userId,
      'product_id': productId,
      'size': size,
      'quantity': quantity,
    });
  }

  // Получить корзину пользователя
  static Future<List<Map<String, dynamic>>> getCart(int userId) async {
    final response = await client
        .from('cart_items')
        .select('''
          *,
          products (
            id,
            name,
            price,
            image_url
          )
        ''')
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  // Обновить количество в корзине
  static Future<void> updateCartItemQuantity(int cartItemId, int quantity) async {
    await client
        .from('cart_items')
        .update({'quantity': quantity})
        .eq('id', cartItemId);
  }

  // Удалить товар из корзины
  static Future<void> removeFromCart(int cartItemId) async {
    await client.from('cart_items').delete().eq('id', cartItemId);
  }

  // Создать заказ
  static Future<int> createOrder(int userId, String fullName, String address, String phone, double totalPrice) async {
    final response = await client.from('orders').insert({
      'user_id': userId,
      'full_name': fullName,
      'address': address,
      'phone': phone,
      'total_price': totalPrice,
      'status': 'pending',
    }).select('id').single();
    
    return response['id'];
  }

  // Добавить товары в заказ
  static Future<void> addOrderItems(int orderId, List<Map<String, dynamic>> items) async {
    for (final item in items) {
      await client.from('order_items').insert({
        'order_id': orderId,
        'product_id': item['product_id'],
        'size': item['size'],
        'quantity': item['quantity'],
        'price': item['price'],
      });
    }
  }

  // Очистить корзину после заказа
  static Future<void> clearCart(int userId) async {
    await client.from('cart_items').delete().eq('user_id', userId);
  }

  // Админ: добавить товар
  static Future<void> addProduct(Map<String, dynamic> productData) async {
    await client.from('products').insert(productData);
  }

  // Админ: обновить товар
  static Future<void> updateProduct(int productId, Map<String, dynamic> productData) async {
    await client
        .from('products')
        .update(productData)
        .eq('id', productId);
  }

  // Админ: удалить товар
  static Future<void> deleteProduct(int productId) async {
    await client.from('products').delete().eq('id', productId);
  }

  // Загрузка изображения
  static Future<String> uploadImage(String bucket, String path, Uint8List bytes) async {
    await client.storage.from(bucket).uploadBinary(path, bytes);
    return client.storage.from(bucket).getPublicUrl(path);
  }
}
