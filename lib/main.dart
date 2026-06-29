import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/app_localizations.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  // TODO: Firebase.initializeApp(...) — `flutterfire configure` çalıştıktan sonra eklenecek.
  runApp(const ProviderScope(child: AlieeWellnessApp()));
}

class AlieeWellnessApp extends StatelessWidget {
  const AlieeWellnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aliee Wellness',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
      localizationsDelegates: const [
        AppL10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr'), Locale('en')],
    );
  }
}
