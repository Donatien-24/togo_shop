import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:togoshop/providers/cart_provider.dart';

import '../helpers/test_data.dart';

void main() {
  test('ajoute un produit au panier avec une quantite', () {
    final notifier = CartNotifier();
    final product = sampleProduct();

    notifier.add(product);

    expect(notifier.state, hasLength(1));
    expect(notifier.state.single.product, product);
    expect(notifier.state.single.quantity, 1);
  });

  test('fusionne les ajouts du meme produit jusqu au stock', () {
    final notifier = CartNotifier();
    final product = sampleProduct(stock: 2);

    notifier.add(product);
    notifier.add(product);
    notifier.add(product);

    expect(notifier.state.single.quantity, 2);
  });

  test('ignore un produit hors stock', () {
    final notifier = CartNotifier();

    notifier.add(sampleProduct(stock: 0));

    expect(notifier.state, isEmpty);
  });

  test('increment et decrement respectent les bornes', () {
    final notifier = CartNotifier();
    final product = sampleProduct(stock: 2);
    notifier.add(product);

    notifier.increment(product.id);
    notifier.increment(product.id);
    notifier.decrement(product.id);

    expect(notifier.state.single.quantity, 1);
  });

  test('supprime un article quand la quantite devient nulle', () {
    final notifier = CartNotifier();
    final product = sampleProduct();
    notifier.add(product);

    notifier.setQuantity(product.id, 0);

    expect(notifier.state, isEmpty);
  });

  test('calcule le nombre d articles et le sous-total', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final product = sampleProduct(price: 2500, stock: 4);
    final notifier = container.read(cartProvider.notifier);

    notifier.add(product);
    notifier.increment(product.id);

    expect(container.read(cartCountProvider), 2);
    expect(container.read(cartSubtotalProvider), 5000);
  });
}
