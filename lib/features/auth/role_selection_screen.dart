import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/botanical_scaffold.dart';
import '../../core/widgets/install_pwa_banner.dart';
import '../../core/widgets/language_switcher.dart';
import 'guest_login_form.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic));
    WidgetsBinding.instance.addPostFrameCallback((_) => _entrance.forward());
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return BotanicalScaffold(
      // Login ekranında sarmaşık tam görünür, yapraklar belirgin
      backgroundOverlay: 0,
      leafOpacity: 0.55,
      body: Stack(
        children: [
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 32),
                        Center(
                          child: SizedBox(
                            width: 110,
                            height: 110,
                            child: Image.asset(
                              'assets/images/leaf_3.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            l.appName,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(letterSpacing: 0.5),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Center(
                          child: Text(
                            l.appTagline,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 40),
                        _GlassCard(
                          child: Column(
                            children: [
                              Text(
                                l.guestLoginTitle,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l.guestLoginSubtitle,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              const GuestLoginForm(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // PWA install banner (web-only, kapatılabilir) — üstte
          Positioned(
            top: MediaQuery.of(context).padding.top + 52,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fade,
              child: const InstallPwaBanner(),
            ),
          ),

          // Sağ üst köşe: dil değiştirici + doktor girişi
          Positioned(
            right: 4,
            top: MediaQuery.of(context).padding.top + 4,
            child: FadeTransition(
              opacity: _fade,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LanguageSwitcherButton(),
                  IconButton(
                    tooltip: l.doctorLogin,
                    onPressed: () => context.push(AppRoutes.doctorLogin),
                    icon: const Icon(Icons.medical_services_outlined,
                        color: AppColors.sageDark),
                  ),
                ],
              ),
            ),
          ),

          // Admin girişi — sol üst, diskret nokta
          Positioned(
            left: 12,
            top: MediaQuery.of(context).padding.top + 12,
            child: GestureDetector(
              onLongPress: () => context.push(AppRoutes.adminLogin),
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.circle, size: 7, color: AppColors.line),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Yarı şeffaf cream üzerine sarılı kart — formun okunmasını sağlar.
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.sageDark.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
