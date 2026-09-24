import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:togoshop/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('parcours navigation catalogue vers panier', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const TogoShopApp(locale: Locale('fr')));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Catalogue'), findsOneWidget);
    await tester.tap(find.text('Panier'));
    await tester.pumpAndSettle();

    expect(find.text('Votre panier est vide'), findsOneWidget);
  });

  testWidgets('parcours favoris et profil', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const TogoShopApp(locale: Locale('fr')));
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.text('Favoris'));
    await tester.pumpAndSettle();
    expect(find.text('Aucun favori pour le moment'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Profil'), findsOneWidget);
  });
}
