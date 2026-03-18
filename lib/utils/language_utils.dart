// lib/utils/language_utils.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageUtils {
  static const String _selectedLanguage = 'selected_language';

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLanguage, languageCode);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedLanguage) ?? 'en'; // Default to English
  }

  Future<bool> hasSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_selectedLanguage);
  }

  Locale getLocale(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return const Locale('hi', 'IN');
      case 'mr':
        return const Locale('mr', 'IN');
      default:
        return const Locale('en', 'US');
    }
  }
}