import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/product.dart';
import 'products_provider.dart';
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier(this._prefs)
      : super(
          _prefs.getStringList(AppConstants.prefsFavoritesKey)?.toSet() ??
              <String>{},
        );
  final SharedPreferences _prefs;
  bool contains(String productId) => state.contains(productId);
  Future<void> toggle(String productId) async {
    final next = {...state};
    if (!next.add(productId)) {
      next.remove(productId);
    }
    state = next;
    await _prefs.setStringList(
      AppConstants.prefsFavoritesKey,
      next.toList(growable: false),
    );
  }
  Future<void> remove(String productId) async {
    if (!state.contains(productId)) return;
    final next = {...state}..remove(productId);
    state = next;
    await _prefs.setStringList(
      AppConstants.prefsFavoritesKey,
      next.toList(growable: false),
    );
  }
}
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier(ref.watch(sharedPreferencesProvider));
});
final favoriteProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final ids = ref.watch(favoritesProvider);
  return ref.watch(productsProvider).whenData((products) {
    return [
      for (final product in products)
        if (ids.contains(product.id)) product,
    ];
  });
});