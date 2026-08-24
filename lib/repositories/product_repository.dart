import 'dart:convert';
import 'package:flutter/services.dart';
import '../core/constants/app_constants.dart';
import '../models/product.dart';
/// Source de données produits : JSON local (assets).
class ProductRepository {
  Future<List<Product>> fetchProducts() async {
    await Future<void>.delayed(AppConstants.catalogLoadDelay);
    final raw = await rootBundle.loadString(AppConstants.productsAssetPath);
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
  Future<Product?> findById(String id) async {
    final products = await fetchProducts();
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  }
}