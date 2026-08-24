import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(const []);
  void add(Product product) {
    if (product.stock <= 0) return;
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index < 0) {
      state = [...state, CartItem(product: product, quantity: 1)];
      return;
    }
    final current = state[index];
    if (current.quantity >= product.stock) return;
    final updated = [...state];
    updated[index] = current.copyWith(quantity: current.quantity + 1);
    state = updated;
  }
  void remove(String productId) {
    state = [
      for (final item in state)
        if (item.product.id != productId) item,
    ];
  }
  void setQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      remove(productId);
      return;
    }
    state = [
      for (final item in state)
        if (item.product.id == productId)
          item.copyWith(
            quantity: quantity.clamp(1, item.product.stock),
          )
        else
          item,
    ];
  }
  void increment(String productId) {
    final item = _find(productId);
    if (item == null) return;
    setQuantity(productId, item.quantity + 1);
  }
  void decrement(String productId) {
    final item = _find(productId);
    if (item == null) return;
    setQuantity(productId, item.quantity - 1);
  }
  void clear() => state = const [];
  CartItem? _find(String productId) {
    for (final item in state) {
      if (item.product.id == productId) return item;
    }
    return null;
  }
}
final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).fold<double>(
        0,
        (sum, item) => sum + item.lineTotal,
      );
});
final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );
});