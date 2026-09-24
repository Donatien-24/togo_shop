import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:togoshop/providers/products_provider.dart';
import 'package:togoshop/widgets/product_card.dart';

import '../helpers/test_data.dart';

void main() {
  testWidgets('affiche une carte produit accessible', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final product = sampleProduct();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              height: 420,
              child: ProductCard(product: product),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text(product.name), findsOneWidget);
    expect(find.bySemanticsLabel(product.name), findsOneWidget);
  });
}
