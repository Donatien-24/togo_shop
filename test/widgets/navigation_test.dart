import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:togoshop/main.dart';
import 'package:togoshop/providers/products_provider.dart';

void main() {
  testWidgets('navigue vers le panier via la navigation principale', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const TogoShopApp(locale: Locale('fr')),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.text('Panier'));
    await tester.pump();

    expect(find.text('Votre panier est vide'), findsOneWidget);
  });
}
