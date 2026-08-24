import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/product_filter.dart';
import '../repositories/product_repository.dart';
import 'filter_provider.dart';
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'Override sharedPreferencesProvider in ProviderScope.',
  );
});
/// Accès au dépôt produits (JSON local).
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});
/// Chargement asynchrone des produits.
final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).fetchProducts();
});
/// Identifiant du produit affiché sur l'écran détail (Riverpod).
final selectedProductIdProvider = StateProvider<String?>((ref) => null);
final selectedProductProvider = Provider<AsyncValue<Product?>>((ref) {
  final id = ref.watch(selectedProductIdProvider);
  final asyncProducts = ref.watch(productsProvider);
  return asyncProducts.whenData((products) {
    if (id == null) return null;
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  });
});
/// Catalogue après recherche, filtre catégorie et tri.
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final filter = ref.watch(filterProvider);
  return ref.watch(productsProvider).whenData((products) {
    var result = products.where((product) {
      final matchesCategory =
          filter.category == 'Tous' || product.category == filter.category;
      final q = filter.query.trim().toLowerCase();
      final matchesQuery =
          q.isEmpty || product.name.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
    switch (filter.sort) {
      case ProductSort.priceAsc:
        result.sort((a, b) => a.price.compareTo(b.price));
      case ProductSort.priceDesc:
        result.sort((a, b) => b.price.compareTo(a.price));
      case ProductSort.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
      case ProductSort.none:
        break;
    }
    return result;
  });
});