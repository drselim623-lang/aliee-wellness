// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppL10nAr extends AppL10n {
  AppL10nAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Aliee Wellness';

  @override
  String get appTagline => 'Spektrum Longevity';

  @override
  String get guestLoginTitle => 'أهلاً وسهلاً';

  @override
  String get guestLoginSubtitle =>
      'سجّل الدخول باستخدام بيانات الاعتماد التي حصلت عليها عند الوصول للفندق';

  @override
  String get passportLast6 => 'جواز السفر (آخر 6 أحرف)';

  @override
  String get roomNumber => 'رقم الغرفة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get doctorLogin => 'دخول الطبيب';

  @override
  String get adminLogin => 'المسؤول';

  @override
  String get guestHomeTitle => 'Aliee Wellness';

  @override
  String get discoverHealth => 'اكتشف صحتك';

  @override
  String get discoverHealthDesc => 'املأ الاستبيان الطبي واحصل على برنامج شخصي';

  @override
  String get services => 'الخدمات';

  @override
  String get servicesDesc => 'الفحوصات، اللوحات، الوريدية والتجميلية';

  @override
  String get askDoctor => 'اسأل طبيبي';

  @override
  String get askDoctorDesc => 'احصل على إجابات من أطبائنا المسجلين';

  @override
  String get planStay => 'الإقامة / الصحة';

  @override
  String get planStayDesc => 'خطط لإقامتك القادمة';

  @override
  String get myProgram => 'برنامجي';

  @override
  String get myProgramDesc => 'شاهد توصياتك المخصصة';

  @override
  String get doctorHomeTitle => 'لوحة الطبيب';

  @override
  String get questionsQueue => 'الأسئلة الواردة';

  @override
  String get noQuestionsYet => 'لا توجد أسئلة بعد';

  @override
  String get adminHomeTitle => 'لوحة المسؤول';

  @override
  String get authorizeGuest => 'منح صلاحية لضيف';

  @override
  String get activeGuests => 'الضيوف النشطون';

  @override
  String get doctors => 'الأطباء';

  @override
  String get passportFull => 'رقم جواز السفر (كامل)';

  @override
  String get submit => 'حفظ';

  @override
  String get language => 'اللغة';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get error => 'خطأ';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get servicesTitle => 'الخدمات';

  @override
  String get categoryTests => 'الفحوصات والتصوير';

  @override
  String get categoryPanels => 'لوحات OM AGE';

  @override
  String get categoryIV => 'IV والوقاية من الشيخوخة';

  @override
  String get categoryAesthetics => 'التجميل الطبي';

  @override
  String get protocolBadge => 'بروتوكول';

  @override
  String get protocolHeading => 'البروتوكول';

  @override
  String get protocolDisclaimer =>
      'جميع المعلومات في هذه الشاشة لأغراض إعلامية فقط. تُتخذ قرارات العلاج والجرعات من قبل فريق Spektrum والأطباء في طابق الصحة في الفندق.';

  @override
  String get noProtocolYet =>
      'لم تتم إضافة بروتوكول مفصل لهذه الخدمة بعد. يرجى التواصل مع فريق Spektrum للمزيد من التفاصيل.';

  @override
  String get programTitle => 'برنامجك';

  @override
  String get programSubtitle =>
      'أُعدّ من الاستبيان الطبي الخاص بك. يُنهى مع فريق Spektrum في طابق الصحة.';

  @override
  String get whyRecommended => 'لماذا يُوصى به';

  @override
  String get updateAnamnesis => 'تحديث الاستبيان';

  @override
  String get programEmptyText =>
      'لا يوجد برنامج بعد.\nأكمل نموذج الاستبيان الطبي.';

  @override
  String get anamnesisStep1Title => 'التاريخ الطبي العام';

  @override
  String get anamnesisStep1Desc =>
      'الأمراض المعروفة، الأدوية، الحساسية والتاريخ العائلي. افصل بين المدخلات بفواصل.';

  @override
  String get fieldChronic => 'الأمراض المزمنة المعروفة';

  @override
  String get fieldChronicHint => 'مثل: ضغط الدم، السكري، الغدة الدرقية';

  @override
  String get fieldMedications => 'الأدوية الحالية';

  @override
  String get fieldMedicationsHint => 'مثل: ميتفورمين، دواء الغدة الدرقية';

  @override
  String get fieldAllergies => 'الحساسية المعروفة';

  @override
  String get fieldAllergiesHint => 'مثل: بنسلين، فول سوداني، غبار';

  @override
  String get fieldFamilyHistory =>
      'التاريخ العائلي (القلب، السرطان، السكري، إلخ.)';

  @override
  String get fieldFamilyHistoryHint => 'مثل: الأم — سرطان الثدي، الأب — القلب';

  @override
  String get fieldSurgeries => 'العمليات السابقة';

  @override
  String get fieldSurgeriesHint => 'مثل: عملية المرارة، حشوات، إلخ.';

  @override
  String get labUploadCta => 'قم بتحميل نتائج المختبر السابقة (صورة).';

  @override
  String get labUploadButton => 'تحميل';

  @override
  String get anamnesisStep2Title => 'نمط الحياة';

  @override
  String get anamnesisStep2Desc => 'عاداتك في النوم والتغذية والتمرين والتوتر.';

  @override
  String get sleepHoursAvg => 'متوسط ساعات النوم';

  @override
  String get hoursSuffix => 'ساعات';

  @override
  String get daysSuffix => 'أيام';

  @override
  String get sleepQuality => 'جودة النوم';

  @override
  String get sleepQualityPoor => 'ضعيف';

  @override
  String get sleepQualityFair => 'متوسط';

  @override
  String get sleepQualityGood => 'جيد';

  @override
  String get dietType => 'نوع النظام الغذائي';

  @override
  String get dietOmnivore => 'متنوع';

  @override
  String get dietVegetarian => 'نباتي';

  @override
  String get dietVegan => 'نباتي صرف';

  @override
  String get dietKeto => 'كيتو';

  @override
  String get dietOther => 'آخر';

  @override
  String get exerciseDaysPerWeek => 'أيام التمرين في الأسبوع';

  @override
  String get iSmoke => 'أنا أدخّن';

  @override
  String get alcoholFrequency => 'تكرار الكحول';

  @override
  String get alcoholNone => 'لا شيء';

  @override
  String get alcoholRarely => 'نادراً';

  @override
  String get alcoholWeekly => 'أسبوعياً';

  @override
  String get alcoholDaily => 'يومياً';

  @override
  String get perceivedStress => 'التوتر المُدرك (1-10)';

  @override
  String get anamnesisStep3Title => 'الشكاوى والأهداف';

  @override
  String get anamnesisStep3Desc =>
      'الشكاوى الحالية وتوقعاتك من برنامج الوقاية من الشيخوخة. افصل بين المدخلات بفواصل.';

  @override
  String get fieldComplaints => 'الشكاوى الحالية';

  @override
  String get fieldComplaintsHint => 'مثل: التعب، مشكلة نوم، مشكلة جلدية';

  @override
  String get fieldGoals => 'أهدافك';

  @override
  String get fieldGoalsHint => 'مثل: مضاد للشيخوخة، طاقة، بشرة، وزن، نوم';

  @override
  String get fieldFreeText => 'شيء آخر تود إضافته';

  @override
  String get submitAndGetProgram => 'أرسل واحصل على التوصيات';

  @override
  String get uploadError => 'خطأ في التحميل';

  @override
  String get submitError => 'تعذر الإرسال';

  @override
  String get askDoctorTitle => 'اسأل طبيبي';

  @override
  String get ourMedicalTeam => 'فريقنا الطبي';

  @override
  String get myConversations => 'محادثاتي';

  @override
  String get noConversationsHint =>
      'لا توجد محادثات بعد. اضغط على طبيب أعلاه لبدء المحادثة.';

  @override
  String get newConversation => 'سؤال جديد';

  @override
  String get typeMessage => 'اكتب رسالة…';

  @override
  String get chooseFromGallery => 'اختر من المعرض';

  @override
  String get camera => 'الكاميرا';

  @override
  String get sendPhoto => 'إرسال صورة';

  @override
  String get chatEmpty =>
      'ستبدأ المحادثة هنا.\nاكتب الرسالة الأولى أو أرسل صورة.';

  @override
  String get sendFailed => 'فشل الإرسال';

  @override
  String get addToHomeTitle => 'إضافة إلى الشاشة الرئيسية';

  @override
  String get addToHomeDesc =>
      'قم بتثبيت Aliee Wellness على جهازك للحصول على تجربة أسرع تشبه التطبيقات.';

  @override
  String get addToHomeIOS => 'iOS (سفاري)';

  @override
  String get addToHomeIOSStep1 => 'اضغط على زر المشاركة في أسفل سفاري.';

  @override
  String get addToHomeIOSStep2 =>
      'قم بالتمرير واختر \"إضافة إلى الشاشة الرئيسية\".';

  @override
  String get addToHomeIOSStep3 => 'أكد الاسم واضغط \"إضافة\".';

  @override
  String get addToHomeAndroid => 'أندرويد (كروم)';

  @override
  String get addToHomeAndroidStep1 =>
      'اضغط على قائمة ⋮ في الزاوية اليمنى العليا.';

  @override
  String get addToHomeAndroidStep2 =>
      'اختر \"تثبيت التطبيق\" أو \"إضافة إلى الشاشة الرئيسية\".';

  @override
  String get addToHomeAndroidStep3 => 'أكد التثبيت.';

  @override
  String get addToHomeDesktop => 'الحاسوب (كروم / إدج)';

  @override
  String get addToHomeDesktopStep1 =>
      'انقر على أيقونة التثبيت في شريط URL (أيقونة شاشة صغيرة).';

  @override
  String get addToHomeDesktopStep2 => 'أكد التثبيت.';

  @override
  String get addToHomeButton => 'تثبيت';

  @override
  String get close => 'إغلاق';

  @override
  String get authorized => 'مُخوَّل';

  @override
  String get guestFirstName => 'الاسم الأول';

  @override
  String get guestLastName => 'اسم العائلة';

  @override
  String get optional => 'اختياري';

  @override
  String get nationality => 'الجنسية';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phone => 'الهاتف';

  @override
  String get guestAuthorizedSuccess =>
      'تم منح الضيف الصلاحية بنجاح. يمكنه تسجيل الدخول بآخر 6 أحرف من جواز السفر ورقم الغرفة.';

  @override
  String get guestUpdatedSuccess =>
      'تم تحديث بيانات الضيف وتمديد الوصول لمدة سنة واحدة.';

  @override
  String get connectionError => 'خطأ في الاتصال.';

  @override
  String get connectionErrorRetry => 'خطأ في الاتصال. يرجى المحاولة مرة أخرى.';

  @override
  String get revokeAccess => 'إلغاء الوصول';

  @override
  String get revokeAccessConfirm => 'هل تريد إلغاء وصول هذا المستخدم؟';

  @override
  String get accessRevoked => 'تم إلغاء الوصول.';

  @override
  String get usernameOrEmail => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get hintAdmin => 'مثال: admin';

  @override
  String get hintDoctor => 'مثال: doctor';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordTooShort => 'قصيرة جداً';

  @override
  String get createDoctor => 'إنشاء طبيب';

  @override
  String get registeredDoctors => 'الأطباء المسجلون';

  @override
  String get noDoctorsYet => 'لا يوجد أطباء بعد.';

  @override
  String get titleField => 'اللقب';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get specialty => 'التخصص';

  @override
  String get temporaryPassword => 'كلمة مرور مؤقتة (8 أحرف على الأقل)';

  @override
  String get doctorAddedSuccess =>
      'تم إنشاء الطبيب. يمكنه الآن تسجيل الدخول بالبريد الإلكتروني وكلمة المرور.';

  @override
  String get loadFailed => 'فشل التحميل';

  @override
  String get expiresLabel => 'ينتهي';

  @override
  String get roomLabel => 'الغرفة';

  @override
  String get next3 => 'التالي';

  @override
  String get submitFinal => 'إرسال والحصول على التوصية';

  @override
  String get step => 'الخطوة';

  @override
  String get requiredField => 'إلزامي';

  @override
  String get noActiveGuests => 'لا يوجد ضيوف نشطون';

  @override
  String get revoke => 'إلغاء';

  @override
  String get addNewDoctor => 'إضافة طبيب جديد';

  @override
  String get inactive => 'غير نشط';

  @override
  String get authErrorSignInFailed => 'تعذر تسجيل الدخول، حاول مرة أخرى.';

  @override
  String get authErrorWrongRole => 'ليست لديك صلاحية لهذه الشاشة.';

  @override
  String get authErrorGuestNotFound =>
      'تعذر التحقق من جواز السفر أو رقم الغرفة.';

  @override
  String get authErrorTooManyAttempts => 'محاولات فاشلة كثيرة. يرجى الانتظار.';

  @override
  String get authErrorInvalidInput => 'المعلومات المدخلة ناقصة أو غير صحيحة.';

  @override
  String get authErrorNoPermission => 'ليست لديك صلاحية لهذا الإجراء.';

  @override
  String get authErrorUnexpected => 'حدث خطأ غير متوقع.';

  @override
  String get authErrorWrongCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get authErrorUserDisabled => 'تم تعطيل حسابك.';
}
