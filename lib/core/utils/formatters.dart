import '../constants/app_constants.dart';
/// Formatage des prix en FCFA sans package `intl`.
String formatPrice(double amount) {
  final digits = amount.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final reverseIndex = digits.length - i;
    buffer.write(digits[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('\u202F');
    }
  }
  return '${buffer.toString()} ${AppConstants.currencySuffix}';
}
String formatRating(double rating) => rating.toStringAsFixed(1);