import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_profile.dart';
import 'products_provider.dart';
class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier(this._prefs) : super(_load(_prefs));
  final SharedPreferences _prefs;
  static UserProfile _load(SharedPreferences prefs) {
    final mock = UserProfile.mock();
    final storedName = prefs.getString(AppConstants.prefsDisplayNameKey);
    if (storedName == null || storedName.trim().isEmpty) return mock;
    return mock.copyWith(name: storedName.trim());
  }
  Future<void> updateDisplayName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    state = state.copyWith(name: trimmed);
    await _prefs.setString(AppConstants.prefsDisplayNameKey, trimmed);
  }
}
final profileProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier(ref.watch(sharedPreferencesProvider));
});
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs) : super(_read(_prefs));
  final SharedPreferences _prefs;
  static ThemeMode _read(SharedPreferences prefs) {
    switch (prefs.getString(AppConstants.prefsThemeModeKey)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(AppConstants.prefsThemeModeKey, value);
  }
}
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(sharedPreferencesProvider));
});