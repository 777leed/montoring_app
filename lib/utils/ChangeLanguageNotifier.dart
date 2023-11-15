import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguage with ChangeNotifier {
  Locale? _currentLocale;

  Locale get currentLocale => _currentLocale ?? Locale('en');

  ChangeLanguage() {
    loadLanguage();
  }

  void changeLocale(Locale newLocale) {
    _currentLocale = newLocale;
    saveLanguage(newLocale.languageCode);
    notifyListeners();
  }

  Future<void> saveLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
    } else {
      _currentLocale = Locale('en');
    }
    notifyListeners();
  }
}
