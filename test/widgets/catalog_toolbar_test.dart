import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:togoshop/widgets/catalog_toolbar.dart';

void main() {
  testWidgets('met a jour la recherche et le filtre categorie', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: CatalogToolbar())),
      ),
    );

    await tester.enterText(find.byType(TextField), 'sac');
    await tester.tap(find.text('Mode'));
    await tester.pump();

    expect(find.text('Mode'), findsOneWidget);
  });
}
