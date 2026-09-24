import 'package:flutter_test/flutter_test.dart';
import 'package:togoshop/models/cart_item.dart';

import '../helpers/test_data.dart';

void main() {
  test('calcule le total de ligne', () {
    final item = CartItem(product: sampleProduct(price: 1800), quantity: 3);

    expect(item.lineTotal, 5400);
  });

  test('copyWith conserve le produit et remplace la quantite', () {
    final product = sampleProduct();
    final item = CartItem(product: product, quantity: 1);

    final copy = item.copyWith(quantity: 4);

    expect(copy.product, product);
    expect(copy.quantity, 4);
  });
}
