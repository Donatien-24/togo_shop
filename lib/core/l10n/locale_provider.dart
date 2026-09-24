import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/products_provider.dart';

const _localeKey = 'locale';

class LocaleNotifier extends StateNotifier<String?> {
  LocaleNotifier(this._prefs) : super(_prefs.getString(_localeKey));

  final SharedPreferences _prefs;

  Future<void> setLocale(String? languageCode) async {
    state = languageCode;
    if (languageCode == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, languageCode);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, String?>((ref) {
  return LocaleNotifier(ref.watch(sharedPreferencesProvider));
});
