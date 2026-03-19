// lib/utils/language_utils.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageUtils {
  static const String _selectedLanguage = 'selected_language';

  Future<void> setLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_selectedLanguage, languageCode);
    } catch (e) {
      print('Error setting language: $e');
    }
  }

  Future<String> getLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_selectedLanguage) ?? 'en';
    } catch (e) {
      print('Error getting language: $e');
      return 'en';
    }
  }

  Future<bool> hasSelectedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_selectedLanguage);
    } catch (e) {
      print('Error checking language: $e');
      return false;
    }
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