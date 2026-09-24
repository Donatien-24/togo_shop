import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:togoshop/models/cart_item.dart';
import 'package:togoshop/providers/cart_provider.dart';
import 'package:togoshop/widgets/cart_item_tile.dart';

import '../helpers/test_data.dart';

void main() {
  testWidgets('affiche le produit et modifie la quantite', (tester) async {
    final product = sampleProduct(stock: 3);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(cartProvider.notifier).add(product);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: CartItemTile(item: CartItem(product: product, quantity: 1)),
          ),
        ),
      ),
    );

    expect(find.text(product.name), findsOneWidget);
    await tester.tap(
      find.byTooltip('Augmenter la quantite de ${product.name}'),
    );
    await tester.pump();

    expect(container.read(cartProvider).single.quantity, 2);
  });
}
