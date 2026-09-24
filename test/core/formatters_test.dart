import 'package:flutter_test/flutter_test.dart';
import 'package:togoshop/core/utils/formatters.dart';

void main() {
  test('formate un prix avec la devise FCFA', () {
    expect(formatPrice(125000), '125 000 FCFA');
  });

  test('formate une note avec une decimale', () {
    expect(formatRating(4), '4.0');
  });
}
