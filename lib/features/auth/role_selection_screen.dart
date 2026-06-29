import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_theme.dart';
import 'guest_login_form.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Misafir akışı (ana akış)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 56),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.sage.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.spa_outlined,
                                size: 36, color: AppColors.sageDark),
                          ),
                          const SizedBox(height: 16),
                          Text(l.appName,
                              style: Theme.of(context).textTheme.displaySmall),
                          const SizedBox(height: 4),
                          Text(l.appTagline,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(l.guestLoginTitle,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 6),
                    Text(l.guestLoginSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    const GuestLoginForm(),
                  ],
                ),
              ),
            ),

            // Doktor girişi — sağ üst köşede ayrı ikon
            Positioned(
              right: 12,
              top: 8,
              child: IconButton(
                tooltip: l.doctorLogin,
                onPressed: () => context.push(AppRoutes.doctorLogin),
                icon: const Icon(Icons.medical_services_outlined,
                    color: AppColors.sageDark),
              ),
            ),

            // Admin girişi — sol üst köşede DİSKRET (misafire reklam edilmez)
            Positioned(
              left: 12,
              top: 8,
              child: GestureDetector(
                onLongPress: () => context.push(AppRoutes.adminLogin),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.circle,
                      size: 8, color: AppColors.line),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
