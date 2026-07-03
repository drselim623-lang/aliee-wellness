import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Uygulama içi dil seçimi. Kullanıcı seçimi SharedPreferences'ta saklanır.
/// Varsayılan dil İngilizce'dir. Seçim yoksa cihaz diline bakılır ve
/// desteklenen listede varsa onu kullanır, yoksa EN'ye düşer.

const List<Locale> kSupportedLocales = [
  Locale('en'), // default
  Locale('tr'),
  Locale('pt'),
  Locale('de'),
  Locale('fr'),
  Locale('ar'),
];

/// (dilKodu → görünen ad) haritası. Kullanıcıya kendi dilinde gösterilir.
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
    if (saved != null && kSupportedLocales.any((l) => l.languageCode == saved)) {
      state = Locale(saved);
      return;
    }
    // Cihaz diline bak; desteklenen listede varsa uygula
    final device =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    if (kSupportedLocales.any((l) => l.languageCode == device)) {
      state = Locale(device);
    }
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
