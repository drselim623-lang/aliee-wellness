import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../pwa/pwa_install.dart';
import '../theme/app_theme.dart';

/// Web'de gösterilen küçük banner: "Aliee Wellness'ı ana ekrana ekle".
/// - Mobile/desktop uygulamada gösterilmez (kIsWeb false)
/// - PWA zaten kurulu (standalone) ise gösterilmez
/// - Kullanıcı kapatırsa `install_banner_dismissed=true` olarak
///   SharedPreferences'a yazılır ve bir daha görünmez.
class InstallPwaBanner extends StatefulWidget {
  const InstallPwaBanner({super.key});

  @override
  State<InstallPwaBanner> createState() => _InstallPwaBannerState();
}

class _InstallPwaBannerState extends State<InstallPwaBanner> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _decideVisibility();
  }

  Future<void> _decideVisibility() async {
    if (!kIsWeb) return;
    if (!PwaInstall.isSupported) return;
    if (PwaInstall.isStandalone) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('install_banner_dismissed') == true) return;
    if (!mounted) return;
    setState(() => _visible = true);
  }

  Future<void> _dismiss() async {
    setState(() => _visible = false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('install_banner_dismissed', true);
  }

  Future<void> _openInstructions() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cream,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _InstallInstructionsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    final l = AppL10n.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: AppColors.sage.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sageDark.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.add_to_home_screen_outlined,
              color: AppColors.sageDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.addToHomeTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.addToHomeDesc,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _openInstructions,
            child: Text(l.addToHomeButton),
          ),
          IconButton(
            iconSize: 18,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: l.close,
            onPressed: _dismiss,
            icon: const Icon(Icons.close, color: AppColors.inkSoft),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _InstallInstructionsSheet extends StatelessWidget {
  const _InstallInstructionsSheet();

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final platform = kIsWeb ? PwaInstall.platform : PwaPlatform.unknown;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.add_to_home_screen_outlined,
                    color: AppColors.sageDark, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.addToHomeTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l.addToHomeDesc,
              style: const TextStyle(color: AppColors.inkSoft),
            ),
            const SizedBox(height: 20),
            _PlatformBlock(
              title: l.addToHomeIOS,
              steps: [
                l.addToHomeIOSStep1,
                l.addToHomeIOSStep2,
                l.addToHomeIOSStep3,
              ],
              expanded: platform == PwaPlatform.ios,
            ),
            _PlatformBlock(
              title: l.addToHomeAndroid,
              steps: [
                l.addToHomeAndroidStep1,
                l.addToHomeAndroidStep2,
                l.addToHomeAndroidStep3,
              ],
              expanded: platform == PwaPlatform.android,
              trailingButton: platform == PwaPlatform.android
                  ? FilledButton(
                      onPressed: () async {
                        final ok = await PwaInstall.promptNativeInstall();
                        if (ok && context.mounted) Navigator.of(context).pop();
                      },
                      child: Text(l.addToHomeButton),
                    )
                  : null,
            ),
            _PlatformBlock(
              title: l.addToHomeDesktop,
              steps: [
                l.addToHomeDesktopStep1,
                l.addToHomeDesktopStep2,
              ],
              expanded: platform == PwaPlatform.desktop,
              trailingButton: platform == PwaPlatform.desktop
                  ? FilledButton(
                      onPressed: () async {
                        final ok = await PwaInstall.promptNativeInstall();
                        if (ok && context.mounted) Navigator.of(context).pop();
                      },
                      child: Text(l.addToHomeButton),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlatformBlock extends StatelessWidget {
  final String title;
  final List<String> steps;
  final bool expanded;
  final Widget? trailingButton;

  const _PlatformBlock({
    required this.title,
    required this.steps,
    required this.expanded,
    this.trailingButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: expanded
            ? AppColors.sage.withValues(alpha: 0.18)
            : AppColors.creamSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: expanded
              ? AppColors.sageDark.withValues(alpha: 0.4)
              : AppColors.line,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: expanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: expanded ? AppColors.sageDark : AppColors.ink,
              fontSize: 14,
            ),
          ),
          iconColor: AppColors.sageDark,
          collapsedIconColor: AppColors.inkSoft,
          children: [
            for (int i = 0; i < steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(
                        color: AppColors.sageDark,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        steps[i],
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (trailingButton != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: trailingButton!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
