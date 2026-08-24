/// Constantes globales de TogoShop.
class AppConstants {
  static const String appName = 'TogoShop';
  static const String productsAssetPath = 'assets/data/products.json';
  static const String currencySuffix = 'FCFA';
  static const String prefsFavoritesKey = 'favorites_ids';
  static const String prefsThemeModeKey = 'theme_mode';
  static const String prefsDisplayNameKey = 'display_name';
  static const List<String> categories = [
    'Tous',
    'Artisanat',
    'Mode',
    'Beauté',
    'Décoration',
    'Alimentaire',
  ];
  static const Duration catalogLoadDelay = Duration(milliseconds: 600);
}