import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:togoshop/models/product_filter.dart';
import 'package:togoshop/providers/filter_provider.dart';
import 'package:togoshop/providers/products_provider.dart';

import '../helpers/test_data.dart';

void main() {
  test('filtre par recherche et trie par prix croissant', () async {
    final container = ProviderContainer(
      overrides: [
        productsProvider.overrideWith((ref) async {
          return [
            sampleProduct(id: '1', name: 'Sac', price: 4000),
            sampleProduct(id: '2', name: 'Collier', price: 1500),
            sampleProduct(id: '3', name: 'Sac tresse', price: 2500),
          ];
        }),
      ],
    );
    addTearDown(container.dispose);
    await container.read(productsProvider.future);

    container.read(filterProvider.notifier).state = const ProductFilter(
      query: 'sac',
      sort: ProductSort.priceAsc,
    );

    final result = container.read(filteredProductsProvider).requireValue;
    expect(result.map((product) => product.name), ['Sac tresse', 'Sac']);
  });

  test('filtre par categorie et trie par note decroissante', () async {
    final container = ProviderContainer(
      overrides: [
        productsProvider.overrideWith((ref) async {
          return [
            sampleProduct(id: '1', category: 'Mode', rating: 3),
            sampleProduct(id: '2', category: 'Mode', rating: 5),
            sampleProduct(id: '3', category: 'Artisanat', rating: 4.9),
          ];
        }),
      ],
    );
    addTearDown(container.dispose);
    await container.read(productsProvider.future);

    container.read(filterProvider.notifier).state = const ProductFilter(
      category: 'Mode',
      sort: ProductSort.rating,
    );

    final result = container.read(filteredProductsProvider).requireValue;
    expect(result.map((product) => product.rating), [5, 3]);
  });
}
