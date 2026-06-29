import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'Aliee Wellness'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In tr, this message translates to:
  /// **'Spektrum Longevity'**
  String get appTagline;

  /// No description provided for @guestLoginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldiniz'**
  String get guestLoginTitle;

  /// No description provided for @guestLoginSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Otel girişinde aldığınız bilgileri kullanarak giriş yapın'**
  String get guestLoginSubtitle;

  /// No description provided for @passportLast6.
  ///
  /// In tr, this message translates to:
  /// **'Pasaport (son 6 hane)'**
  String get passportLast6;

  /// No description provided for @roomNumber.
  ///
  /// In tr, this message translates to:
  /// **'Oda numarası'**
  String get roomNumber;

  /// No description provided for @login.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get login;

  /// No description provided for @doctorLogin.
  ///
  /// In tr, this message translates to:
  /// **'Doktor girişi'**
  String get doctorLogin;

  /// No description provided for @adminLogin.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici'**
  String get adminLogin;

  /// No description provided for @guestHomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aliee Wellness'**
  String get guestHomeTitle;

  /// No description provided for @discoverHealth.
  ///
  /// In tr, this message translates to:
  /// **'Sağlığını Keşfet'**
  String get discoverHealth;

  /// No description provided for @discoverHealthDesc.
  ///
  /// In tr, this message translates to:
  /// **'Anamnez doldur, kişiye özel program öner'**
  String get discoverHealthDesc;

  /// No description provided for @services.
  ///
  /// In tr, this message translates to:
  /// **'Hizmetler'**
  String get services;

  /// No description provided for @servicesDesc.
  ///
  /// In tr, this message translates to:
  /// **'Testler, paneller, IV ve estetik'**
  String get servicesDesc;

  /// No description provided for @askDoctor.
  ///
  /// In tr, this message translates to:
  /// **'Doktoruma Sor'**
  String get askDoctor;

  /// No description provided for @askDoctorDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı doktorlardan yanıt al'**
  String get askDoctorDesc;

  /// No description provided for @planStay.
  ///
  /// In tr, this message translates to:
  /// **'Konaklama / Wellness'**
  String get planStay;

  /// No description provided for @planStayDesc.
  ///
  /// In tr, this message translates to:
  /// **'Gelecek konaklamanızı planlayın'**
  String get planStayDesc;

  /// No description provided for @doctorHomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Doktor Paneli'**
  String get doctorHomeTitle;

  /// No description provided for @questionsQueue.
  ///
  /// In tr, this message translates to:
  /// **'Gelen sorular'**
  String get questionsQueue;

  /// No description provided for @noQuestionsYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz soru yok'**
  String get noQuestionsYet;

  /// No description provided for @adminHomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim Paneli'**
  String get adminHomeTitle;

  /// No description provided for @authorizeGuest.
  ///
  /// In tr, this message translates to:
  /// **'Misafir yetkilendir'**
  String get authorizeGuest;

  /// No description provided for @activeGuests.
  ///
  /// In tr, this message translates to:
  /// **'Aktif misafirler'**
  String get activeGuests;

  /// No description provided for @passportFull.
  ///
  /// In tr, this message translates to:
  /// **'Pasaport numarası (tam)'**
  String get passportFull;

  /// No description provided for @submit.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get submit;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
    case 'tr':
      return AppL10nTr();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
