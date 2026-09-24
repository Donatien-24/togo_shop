import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:togoshop/widgets/price_tag.dart';

void main() {
  testWidgets('affiche le prix et la devise', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: PriceTag(price: 125000))),
    );

    expect(find.text('125 000 FCFA'), findsOneWidget);
  });
}
