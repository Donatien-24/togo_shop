import 'package:flutter_test/flutter_test.dart';

import 'package:togoshop/providers/favorites_provider.dart';

import '../helpers/test_data.dart';
import '../helpers/test_preferences.dart';

void main() {
  test('ajoute puis retire un favori et le persiste', () async {
    final prefs = await buildTestPreferences();
    final notifier = FavoritesNotifier(prefs);
    final product = sampleProduct();

    await notifier.toggle(product.id);
    expect(notifier.contains(product.id), isTrue);
    expect(prefs.getStringList('favorites_ids'), [product.id]);

    await notifier.toggle(product.id);
    expect(notifier.contains(product.id), isFalse);
    expect(prefs.getStringList('favorites_ids'), isEmpty);
  });

  test('remove ignore un identifiant absent', () async {
    final prefs = await buildTestPreferences();
    final notifier = FavoritesNotifier(prefs);

    await notifier.remove('missing');

    expect(notifier.state, isEmpty);
  });
}
