import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Uygulama içi dil seçimi. Varsayılan İngilizce.
/// Kullanıcı bir dil seçtiyse tercihi SharedPreferences'ta saklanır ve
/// bir sonraki açılışta kullanılır. Cihaz dili **yok sayılır** —
/// kullanıcı açıkça seçmeden farklı bir dile geçilmez.

const List<Locale> kSupportedLocales = [
  Locale('en'), // default
  Locale('tr'),
  Locale('pt'),
  Locale('de'),
  Locale('fr'),
  Locale('ar'),
];

const Map<String, String> kLanguageNames = {
  'en': 'English',
  'tr': 'Türkçe',
  'pt': 'Português',
  'de': 'Deutsch',
  'fr': 'Français',
  'ar': 'العربية',
};

const _prefsKey = 'app_locale';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null &&
        kSupportedLocales.any((l) => l.languageCode == saved)) {
      state = Locale(saved);
    }
    // Aksi halde İngilizce kalır — cihaz dili bilinçli olarak KULLANILMIYOR.
  }

  Future<void> set(Locale locale) async {
    if (!kSupportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      return;
    }
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
