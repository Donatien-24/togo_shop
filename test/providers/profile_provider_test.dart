import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:togoshop/providers/profile_provider.dart';

import '../helpers/test_preferences.dart';

void main() {
  test('restaure le nom affiche depuis les preferences', () async {
    final prefs = await buildTestPreferences({'display_name': '  Kossi  '});
    final notifier = ProfileNotifier(prefs);

    expect(notifier.state.name, 'Kossi');
  });

  test('met a jour et persiste un nom valide', () async {
    final prefs = await buildTestPreferences();
    final notifier = ProfileNotifier(prefs);

    await notifier.updateDisplayName('  Ama  ');

    expect(notifier.state.name, 'Ama');
    expect(prefs.getString('display_name'), 'Ama');
  });

  test('restaure et persiste le mode de theme', () async {
    final prefs = await buildTestPreferences({'theme_mode': 'dark'});
    final notifier = ThemeModeNotifier(prefs);

    expect(notifier.state, ThemeMode.dark);

    await notifier.setMode(ThemeMode.light);
    expect(prefs.getString('theme_mode'), 'light');
  });
}
