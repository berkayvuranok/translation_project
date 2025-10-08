import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcının tema ve dil tercihlerini cihaz hafızasına kaydeden ve
/// oradan okuyan sınıf.
class SettingsRepository {
  static const String _themeKey = 'theme';
  static const String _languageKey = 'language';

  Future<void> saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode.name);
  }

  Future<ThemeMode> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themeKey);
    // Kayıtlı tema varsa onu, yoksa sistem temasını varsayılan yap.
    return ThemeMode.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> saveLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }

  Future<Locale?> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);
    return languageCode != null ? Locale(languageCode) : null;
  }
}
