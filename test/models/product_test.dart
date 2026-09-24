import 'package:flutter_test/flutter_test.dart';
import 'package:togoshop/models/product.dart';

void main() {
  test('deserialise et serialise un produit', () {
    final product = Product.fromJson({
      'id': 'p1',
      'name': 'Tunique',
      'description': 'Coton local',
      'price': 12000,
      'imageUrl': 'https://example.com/tunique.jpg',
      'category': 'Mode',
      'rating': 4.2,
      'stock': 2,
    });

    expect(product.isInStock, isTrue);
    expect(Product.fromJson(product.toJson()), product);
  });

  test('signale un JSON produit incomplet', () {
    expect(() => Product.fromJson({'id': 'p1'}), throwsA(isA<TypeError>()));
  });
}
