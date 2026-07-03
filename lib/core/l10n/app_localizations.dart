import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
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
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('pt'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Aliee Wellness'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Spektrum Longevity'**
  String get appTagline;

  /// No description provided for @guestLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get guestLoginTitle;

  /// No description provided for @guestLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with the credentials given at hotel check-in'**
  String get guestLoginSubtitle;

  /// No description provided for @passportLast6.
  ///
  /// In en, this message translates to:
  /// **'Passport (last 6 characters)'**
  String get passportLast6;

  /// No description provided for @roomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room number'**
  String get roomNumber;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login;

  /// No description provided for @doctorLogin.
  ///
  /// In en, this message translates to:
  /// **'Doctor sign-in'**
  String get doctorLogin;

  /// No description provided for @adminLogin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminLogin;

  /// No description provided for @guestHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Aliee Wellness'**
  String get guestHomeTitle;

  /// No description provided for @discoverHealth.
  ///
  /// In en, this message translates to:
  /// **'Discover Your Health'**
  String get discoverHealth;

  /// No description provided for @discoverHealthDesc.
  ///
  /// In en, this message translates to:
  /// **'Fill in the anamnesis, receive a personal program'**
  String get discoverHealthDesc;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @servicesDesc.
  ///
  /// In en, this message translates to:
  /// **'Tests, panels, IV and aesthetics'**
  String get servicesDesc;

  /// No description provided for @askDoctor.
  ///
  /// In en, this message translates to:
  /// **'Ask My Doctor'**
  String get askDoctor;

  /// No description provided for @askDoctorDesc.
  ///
  /// In en, this message translates to:
  /// **'Get answers from our registered doctors'**
  String get askDoctorDesc;

  /// No description provided for @planStay.
  ///
  /// In en, this message translates to:
  /// **'Stay / Wellness'**
  String get planStay;

  /// No description provided for @planStayDesc.
  ///
  /// In en, this message translates to:
  /// **'Plan your next stay'**
  String get planStayDesc;

  /// No description provided for @myProgram.
  ///
  /// In en, this message translates to:
  /// **'My Program'**
  String get myProgram;

  /// No description provided for @myProgramDesc.
  ///
  /// In en, this message translates to:
  /// **'See your personalized service recommendations'**
  String get myProgramDesc;

  /// No description provided for @doctorHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor Panel'**
  String get doctorHomeTitle;

  /// No description provided for @questionsQueue.
  ///
  /// In en, this message translates to:
  /// **'Incoming questions'**
  String get questionsQueue;

  /// No description provided for @noQuestionsYet.
  ///
  /// In en, this message translates to:
  /// **'No questions yet'**
  String get noQuestionsYet;

  /// No description provided for @adminHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminHomeTitle;

  /// No description provided for @authorizeGuest.
  ///
  /// In en, this message translates to:
  /// **'Authorize guest'**
  String get authorizeGuest;

  /// No description provided for @activeGuests.
  ///
  /// In en, this message translates to:
  /// **'Active guests'**
  String get activeGuests;

  /// No description provided for @doctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// No description provided for @passportFull.
  ///
  /// In en, this message translates to:
  /// **'Passport number (full)'**
  String get passportFull;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get submit;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @servicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTitle;

  /// No description provided for @categoryTests.
  ///
  /// In en, this message translates to:
  /// **'Tests & Imaging'**
  String get categoryTests;

  /// No description provided for @categoryPanels.
  ///
  /// In en, this message translates to:
  /// **'OM AGE Panels'**
  String get categoryPanels;

  /// No description provided for @categoryIV.
  ///
  /// In en, this message translates to:
  /// **'IV & Longevity'**
  String get categoryIV;

  /// No description provided for @categoryAesthetics.
  ///
  /// In en, this message translates to:
  /// **'Medical Aesthetics'**
  String get categoryAesthetics;

  /// No description provided for @protocolBadge.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get protocolBadge;

  /// No description provided for @protocolHeading.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get protocolHeading;

  /// No description provided for @protocolDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'All information on this screen is for informational purposes only. Treatment and dosing decisions are made by the Spektrum team and doctors at the wellness floor of the hotel.'**
  String get protocolDisclaimer;

  /// No description provided for @noProtocolYet.
  ///
  /// In en, this message translates to:
  /// **'Detailed protocol for this service has not been added yet. Please contact the Spektrum team for details.'**
  String get noProtocolYet;

  /// No description provided for @programTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Program'**
  String get programTitle;

  /// No description provided for @programSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prepared from your anamnesis. It is finalized with the Spektrum team at the wellness floor.'**
  String get programSubtitle;

  /// No description provided for @whyRecommended.
  ///
  /// In en, this message translates to:
  /// **'Why recommended'**
  String get whyRecommended;

  /// No description provided for @updateAnamnesis.
  ///
  /// In en, this message translates to:
  /// **'Update anamnesis'**
  String get updateAnamnesis;

  /// No description provided for @programEmptyText.
  ///
  /// In en, this message translates to:
  /// **'No program yet.\nComplete the anamnesis form.'**
  String get programEmptyText;

  /// No description provided for @anamnesisStep1Title.
  ///
  /// In en, this message translates to:
  /// **'General medical history'**
  String get anamnesisStep1Title;

  /// No description provided for @anamnesisStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Known conditions, medications, allergies and family history. Separate multiple entries with commas.'**
  String get anamnesisStep1Desc;

  /// No description provided for @fieldChronic.
  ///
  /// In en, this message translates to:
  /// **'Known chronic conditions'**
  String get fieldChronic;

  /// No description provided for @fieldChronicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. hypertension, diabetes, thyroid'**
  String get fieldChronicHint;

  /// No description provided for @fieldMedications.
  ///
  /// In en, this message translates to:
  /// **'Current medications'**
  String get fieldMedications;

  /// No description provided for @fieldMedicationsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. metformin, thyroid medicine'**
  String get fieldMedicationsHint;

  /// No description provided for @fieldAllergies.
  ///
  /// In en, this message translates to:
  /// **'Known allergies'**
  String get fieldAllergies;

  /// No description provided for @fieldAllergiesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. penicillin, peanut, pollen'**
  String get fieldAllergiesHint;

  /// No description provided for @fieldFamilyHistory.
  ///
  /// In en, this message translates to:
  /// **'Family history (heart, cancer, diabetes, etc.)'**
  String get fieldFamilyHistory;

  /// No description provided for @fieldFamilyHistoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. mother — breast cancer, father — heart'**
  String get fieldFamilyHistoryHint;

  /// No description provided for @fieldSurgeries.
  ///
  /// In en, this message translates to:
  /// **'Past surgeries'**
  String get fieldSurgeries;

  /// No description provided for @fieldSurgeriesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. gallbladder surgery, filler, etc.'**
  String get fieldSurgeriesHint;

  /// No description provided for @labUploadCta.
  ///
  /// In en, this message translates to:
  /// **'Upload past lab results (photo).'**
  String get labUploadCta;

  /// No description provided for @labUploadButton.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get labUploadButton;

  /// No description provided for @anamnesisStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get anamnesisStep2Title;

  /// No description provided for @anamnesisStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Your sleep, nutrition, exercise and stress habits.'**
  String get anamnesisStep2Desc;

  /// No description provided for @sleepHoursAvg.
  ///
  /// In en, this message translates to:
  /// **'Average sleep hours'**
  String get sleepHoursAvg;

  /// No description provided for @hoursSuffix.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hoursSuffix;

  /// No description provided for @daysSuffix.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysSuffix;

  /// No description provided for @sleepQuality.
  ///
  /// In en, this message translates to:
  /// **'Sleep quality'**
  String get sleepQuality;

  /// No description provided for @sleepQualityPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get sleepQualityPoor;

  /// No description provided for @sleepQualityFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get sleepQualityFair;

  /// No description provided for @sleepQualityGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get sleepQualityGood;

  /// No description provided for @dietType.
  ///
  /// In en, this message translates to:
  /// **'Diet type'**
  String get dietType;

  /// No description provided for @dietOmnivore.
  ///
  /// In en, this message translates to:
  /// **'Omnivore'**
  String get dietOmnivore;

  /// No description provided for @dietVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get dietVegetarian;

  /// No description provided for @dietVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get dietVegan;

  /// No description provided for @dietKeto.
  ///
  /// In en, this message translates to:
  /// **'Keto'**
  String get dietKeto;

  /// No description provided for @dietOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get dietOther;

  /// No description provided for @exerciseDaysPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Exercise days per week'**
  String get exerciseDaysPerWeek;

  /// No description provided for @iSmoke.
  ///
  /// In en, this message translates to:
  /// **'I smoke'**
  String get iSmoke;

  /// No description provided for @alcoholFrequency.
  ///
  /// In en, this message translates to:
  /// **'Alcohol frequency'**
  String get alcoholFrequency;

  /// No description provided for @alcoholNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get alcoholNone;

  /// No description provided for @alcoholRarely.
  ///
  /// In en, this message translates to:
  /// **'Rarely'**
  String get alcoholRarely;

  /// No description provided for @alcoholWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get alcoholWeekly;

  /// No description provided for @alcoholDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get alcoholDaily;

  /// No description provided for @perceivedStress.
  ///
  /// In en, this message translates to:
  /// **'Perceived stress (1-10)'**
  String get perceivedStress;

  /// No description provided for @anamnesisStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Complaints & goals'**
  String get anamnesisStep3Title;

  /// No description provided for @anamnesisStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Current complaints and your expectations from the longevity program. Separate multiple with commas.'**
  String get anamnesisStep3Desc;

  /// No description provided for @fieldComplaints.
  ///
  /// In en, this message translates to:
  /// **'Current complaints'**
  String get fieldComplaints;

  /// No description provided for @fieldComplaintsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. fatigue, sleep problem, skin issue'**
  String get fieldComplaintsHint;

  /// No description provided for @fieldGoals.
  ///
  /// In en, this message translates to:
  /// **'Your goals'**
  String get fieldGoals;

  /// No description provided for @fieldGoalsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. anti-aging, energy, skin, weight, sleep'**
  String get fieldGoalsHint;

  /// No description provided for @fieldFreeText.
  ///
  /// In en, this message translates to:
  /// **'Anything else you would like to add'**
  String get fieldFreeText;

  /// No description provided for @submitAndGetProgram.
  ///
  /// In en, this message translates to:
  /// **'Submit and get recommendations'**
  String get submitAndGetProgram;

  /// No description provided for @uploadError.
  ///
  /// In en, this message translates to:
  /// **'Upload error'**
  String get uploadError;

  /// No description provided for @submitError.
  ///
  /// In en, this message translates to:
  /// **'Could not submit'**
  String get submitError;

  /// No description provided for @askDoctorTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask My Doctor'**
  String get askDoctorTitle;

  /// No description provided for @ourMedicalTeam.
  ///
  /// In en, this message translates to:
  /// **'Our Medical Team'**
  String get ourMedicalTeam;

  /// No description provided for @myConversations.
  ///
  /// In en, this message translates to:
  /// **'My Conversations'**
  String get myConversations;

  /// No description provided for @noConversationsHint.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet. Tap a doctor above to start a chat.'**
  String get noConversationsHint;

  /// No description provided for @newConversation.
  ///
  /// In en, this message translates to:
  /// **'New Question'**
  String get newConversation;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message…'**
  String get typeMessage;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @sendPhoto.
  ///
  /// In en, this message translates to:
  /// **'Send photo'**
  String get sendPhoto;

  /// No description provided for @chatEmpty.
  ///
  /// In en, this message translates to:
  /// **'The conversation will start here.\nWrite the first message or send a photo.'**
  String get chatEmpty;

  /// No description provided for @sendFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send'**
  String get sendFailed;

  /// No description provided for @addToHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to Home Screen'**
  String get addToHomeTitle;

  /// No description provided for @addToHomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Install Aliee Wellness on your device for a faster, app-like experience.'**
  String get addToHomeDesc;

  /// No description provided for @addToHomeIOS.
  ///
  /// In en, this message translates to:
  /// **'iOS (Safari)'**
  String get addToHomeIOS;

  /// No description provided for @addToHomeIOSStep1.
  ///
  /// In en, this message translates to:
  /// **'Tap the Share button at the bottom of Safari.'**
  String get addToHomeIOSStep1;

  /// No description provided for @addToHomeIOSStep2.
  ///
  /// In en, this message translates to:
  /// **'Scroll and select \"Add to Home Screen\".'**
  String get addToHomeIOSStep2;

  /// No description provided for @addToHomeIOSStep3.
  ///
  /// In en, this message translates to:
  /// **'Confirm the name and tap \"Add\".'**
  String get addToHomeIOSStep3;

  /// No description provided for @addToHomeAndroid.
  ///
  /// In en, this message translates to:
  /// **'Android (Chrome)'**
  String get addToHomeAndroid;

  /// No description provided for @addToHomeAndroidStep1.
  ///
  /// In en, this message translates to:
  /// **'Tap the ⋮ menu in the top-right corner.'**
  String get addToHomeAndroidStep1;

  /// No description provided for @addToHomeAndroidStep2.
  ///
  /// In en, this message translates to:
  /// **'Select \"Install app\" or \"Add to Home Screen\".'**
  String get addToHomeAndroidStep2;

  /// No description provided for @addToHomeAndroidStep3.
  ///
  /// In en, this message translates to:
  /// **'Confirm the installation.'**
  String get addToHomeAndroidStep3;

  /// No description provided for @addToHomeDesktop.
  ///
  /// In en, this message translates to:
  /// **'Desktop (Chrome / Edge)'**
  String get addToHomeDesktop;

  /// No description provided for @addToHomeDesktopStep1.
  ///
  /// In en, this message translates to:
  /// **'Click the install icon in the URL bar (a small monitor icon).'**
  String get addToHomeDesktopStep1;

  /// No description provided for @addToHomeDesktopStep2.
  ///
  /// In en, this message translates to:
  /// **'Confirm the installation.'**
  String get addToHomeDesktopStep2;

  /// No description provided for @addToHomeButton.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get addToHomeButton;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @authorized.
  ///
  /// In en, this message translates to:
  /// **'Authorized'**
  String get authorized;

  /// No description provided for @guestFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get guestFirstName;

  /// No description provided for @guestLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get guestLastName;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @guestAuthorizedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Guest successfully authorized. They can sign in with the last 6 characters of their passport and room number.'**
  String get guestAuthorizedSuccess;

  /// No description provided for @guestUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Guest details updated and access extended by 1 year.'**
  String get guestUpdatedSuccess;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error.'**
  String get connectionError;

  /// No description provided for @connectionErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please try again.'**
  String get connectionErrorRetry;

  /// No description provided for @revokeAccess.
  ///
  /// In en, this message translates to:
  /// **'Revoke access'**
  String get revokeAccess;

  /// No description provided for @revokeAccessConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to revoke access for this user?'**
  String get revokeAccessConfirm;

  /// No description provided for @accessRevoked.
  ///
  /// In en, this message translates to:
  /// **'Access revoked.'**
  String get accessRevoked;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Username or e-mail'**
  String get usernameOrEmail;

  /// No description provided for @hintAdmin.
  ///
  /// In en, this message translates to:
  /// **'e.g. admin'**
  String get hintAdmin;

  /// No description provided for @hintDoctor.
  ///
  /// In en, this message translates to:
  /// **'e.g. doctor'**
  String get hintDoctor;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Too short'**
  String get passwordTooShort;

  /// No description provided for @createDoctor.
  ///
  /// In en, this message translates to:
  /// **'Create Doctor'**
  String get createDoctor;

  /// No description provided for @registeredDoctors.
  ///
  /// In en, this message translates to:
  /// **'Registered doctors'**
  String get registeredDoctors;

  /// No description provided for @noDoctorsYet.
  ///
  /// In en, this message translates to:
  /// **'No doctors yet.'**
  String get noDoctorsYet;

  /// No description provided for @titleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleField;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @specialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get specialty;

  /// No description provided for @temporaryPassword.
  ///
  /// In en, this message translates to:
  /// **'Temporary password (min 8 chars)'**
  String get temporaryPassword;

  /// No description provided for @doctorAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Doctor created. They can now sign in with e-mail and password.'**
  String get doctorAddedSuccess;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get loadFailed;

  /// No description provided for @expiresLabel.
  ///
  /// In en, this message translates to:
  /// **'expires'**
  String get expiresLabel;

  /// No description provided for @roomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get roomLabel;

  /// No description provided for @next3.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next3;

  /// No description provided for @submitFinal.
  ///
  /// In en, this message translates to:
  /// **'Submit and get recommendation'**
  String get submitFinal;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @noActiveGuests.
  ///
  /// In en, this message translates to:
  /// **'No active guests'**
  String get noActiveGuests;

  /// No description provided for @revoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get revoke;

  /// No description provided for @addNewDoctor.
  ///
  /// In en, this message translates to:
  /// **'Add new doctor'**
  String get addNewDoctor;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @authErrorSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in, please try again.'**
  String get authErrorSignInFailed;

  /// No description provided for @authErrorWrongRole.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized for this screen.'**
  String get authErrorWrongRole;

  /// No description provided for @authErrorGuestNotFound.
  ///
  /// In en, this message translates to:
  /// **'Passport or room number could not be verified.'**
  String get authErrorGuestNotFound;

  /// No description provided for @authErrorTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts. Please wait.'**
  String get authErrorTooManyAttempts;

  /// No description provided for @authErrorInvalidInput.
  ///
  /// In en, this message translates to:
  /// **'The information entered is missing or incorrect.'**
  String get authErrorInvalidInput;

  /// No description provided for @authErrorNoPermission.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized for this action.'**
  String get authErrorNoPermission;

  /// No description provided for @authErrorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get authErrorUnexpected;

  /// No description provided for @authErrorWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect e-mail or password.'**
  String get authErrorWrongCredentials;

  /// No description provided for @authErrorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'Your account has been disabled.'**
  String get authErrorUserDisabled;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'fr',
    'pt',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppL10nAr();
    case 'de':
      return AppL10nDe();
    case 'en':
      return AppL10nEn();
    case 'fr':
      return AppL10nFr();
    case 'pt':
      return AppL10nPt();
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
