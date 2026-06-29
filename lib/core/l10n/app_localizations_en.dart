// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Aliee Wellness';

  @override
  String get appTagline => 'Spektrum Longevity';

  @override
  String get guestLoginTitle => 'Welcome';

  @override
  String get guestLoginSubtitle =>
      'Use the credentials provided at hotel check-in';

  @override
  String get passportLast6 => 'Passport (last 6 digits)';

  @override
  String get roomNumber => 'Room number';

  @override
  String get login => 'Sign in';

  @override
  String get doctorLogin => 'Doctor sign-in';

  @override
  String get adminLogin => 'Admin';

  @override
  String get guestHomeTitle => 'Aliee Wellness';

  @override
  String get discoverHealth => 'Discover Your Health';

  @override
  String get discoverHealthDesc => 'Fill the anamnesis, get a personal program';

  @override
  String get services => 'Services';

  @override
  String get servicesDesc => 'Tests, panels, IVs and aesthetics';

  @override
  String get askDoctor => 'Ask My Doctor';

  @override
  String get askDoctorDesc => 'Get answers from registered doctors';

  @override
  String get planStay => 'Stay / Wellness';

  @override
  String get planStayDesc => 'Plan your next stay';

  @override
  String get doctorHomeTitle => 'Doctor Panel';

  @override
  String get questionsQueue => 'Incoming questions';

  @override
  String get noQuestionsYet => 'No questions yet';

  @override
  String get adminHomeTitle => 'Admin Panel';

  @override
  String get authorizeGuest => 'Authorize guest';

  @override
  String get activeGuests => 'Active guests';

  @override
  String get passportFull => 'Passport number (full)';

  @override
  String get submit => 'Save';

  @override
  String get language => 'Language';
}
