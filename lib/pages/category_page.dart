import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/supabase_service.dart';
import '../services/telegram_service.dart';
import '../widgets/product_card.dart';
import '../widgets/admin_panel.dart';
import 'product_page.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Product> products = [];
  bool isLoading = true;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _checkAdminStatus();
  }

  Future<void> _loadProducts() async {
    try {
      final productsData = await SupabaseService.getProductsByCategory(widget.category.id);
      setState(() {
        products = productsData.map((json) => Product.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки товаров: $e')),
        );
      }
    }
  }

  void _checkAdminStatus() {
    setState(() {
      isAdmin = TelegramService.isAdmin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: Text(
          widget.category.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Админ-панель
          if (isAdmin)
            AdminPanel(
              categoryId: widget.category.id,
              onProductAdded: _loadProducts,
              onProductUpdated: _loadProducts,
              onProductDeleted: _loadProducts,
            ),
          
          // Список товаров
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  )
                : products.isEmpty
                    ? const Center(
                        child: Text(
                          'Товары не найдены',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        color: Colors.red,
                        onRefresh: _loadProducts,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductPage(product: product),
                                  ),
                                ).then((_) => _loadProducts());
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
