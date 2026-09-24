// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:togoshop/main.dart';
import 'package:togoshop/providers/products_provider.dart';

void main() {
  testWidgets('TogoShop affiche la navigation principale', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const TogoShopApp(locale: Locale('fr')),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('TogoShop'), findsOneWidget);
    expect(find.text('Catalogue'), findsOneWidget);
    expect(find.text('Favoris'), findsOneWidget);
    expect(find.text('Panier'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
