import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../pwa/pwa_install.dart';
import '../theme/app_theme.dart';
import 'install_illustrations.dart';

const _prefsInstalledKey = 'pwa_installed';

/// Web'de gösterilen küçük banner: "Add to Home Screen".
/// Tüm banner tıklanabilir — tıklayınca görselli talimatlar açılır.
/// Uygulama zaten kurulu (standalone) veya kurulmuş olarak işaretlenmişse hiç görünmez.
class InstallPwaBanner extends StatefulWidget {
  const InstallPwaBanner({super.key});

  @override
  State<InstallPwaBanner> createState() => _InstallPwaBannerState();
}

class _InstallPwaBannerState extends State<InstallPwaBanner> {
  bool _visible = false;
  void Function()? _installedListener;

  @override
  void initState() {
    super.initState();
    _decideVisibility();
    if (kIsWeb && PwaInstall.isSupported) {
      _installedListener = () async {
        // Kurulum tamamlandı — banner'ı kalıcı olarak gizle
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_prefsInstalledKey, true);
        if (mounted) setState(() => _visible = false);
      };
      PwaInstall.addInstalledListener(_installedListener!);
    }
  }

  @override
  void dispose() {
    if (_installedListener != null) {
      PwaInstall.removeInstalledListener(_installedListener!);
    }
    super.dispose();
  }

  Future<void> _decideVisibility() async {
    if (!kIsWeb || !PwaInstall.isSupported) return;
    if (PwaInstall.isStandalone) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_prefsInstalledKey) == true) return;
    if (!mounted) return;
    setState(() => _visible = true);
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
    // Modal kapandıktan sonra standalone durumunu yeniden kontrol et —
    // kullanıcı gerçekten kurmuşsa banner otomatik kaybolur
    if (kIsWeb && PwaInstall.isStandalone && mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsInstalledKey, true);
      setState(() => _visible = false);
    }
  }

  Future<void> _dismiss() async {
    setState(() => _visible = false);
    final prefs = await SharedPreferences.getInstance();
    // Kullanıcı kapatırsa: sadece bu tarayıcı oturumu için gizle
    // (silinsin diye kalıcı flag yerine geçici — ama hızlı UX için kalıcı yapıyoruz)
    await prefs.setBool(_prefsInstalledKey, true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    final l = AppL10n.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      decoration: BoxDecoration(
        color: AppColors.sage.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sageDark.withValues(alpha: 0.35)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openInstructions,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
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
                const Icon(Icons.chevron_right,
                    color: AppColors.sageDark, size: 20),
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
          ),
        ),
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
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.add_to_home_screen_outlined,
                      color: AppColors.sageDark, size: 24),
                  const SizedBox(width: 10),
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
              const SizedBox(height: 6),
              Text(
                l.addToHomeDesc,
                style: const TextStyle(color: AppColors.inkSoft),
              ),
              const SizedBox(height: 24),

              _IOSBlock(expanded: platform == PwaPlatform.ios),
              const SizedBox(height: 12),
              _AndroidBlock(
                expanded: platform == PwaPlatform.android,
              ),
              const SizedBox(height: 12),
              _DesktopBlock(
                expanded: platform == PwaPlatform.desktop,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlatformExpansion extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool expanded;
  final List<Widget> children;

  const _PlatformExpansion({
    required this.title,
    required this.icon,
    required this.expanded,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: expanded
            ? AppColors.sage.withValues(alpha: 0.15)
            : AppColors.creamSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: expanded
              ? AppColors.sageDark.withValues(alpha: 0.4)
              : AppColors.line,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: expanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
          leading: Icon(icon,
              color: expanded ? AppColors.sageDark : AppColors.inkSoft),
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
          children: children,
        ),
      ),
    );
  }
}

Widget _stepBadge(int n, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.only(top: 1),
        decoration: BoxDecoration(
          color: AppColors.sageDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text('$n',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              )),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 14,
            height: 1.45,
          ),
        ),
      ),
    ],
  );
}

class _IOSBlock extends StatelessWidget {
  final bool expanded;
  const _IOSBlock({required this.expanded});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return _PlatformExpansion(
      title: l.addToHomeIOS,
      icon: Icons.phone_iphone,
      expanded: expanded,
      children: [
        _stepBadge(1, l.addToHomeIOSStep1),
        const IOSShareIllustration(),
        const SizedBox(height: 16),
        _stepBadge(2, l.addToHomeIOSStep2),
        const IOSAddToHomeIllustration(),
        const SizedBox(height: 16),
        _stepBadge(3, l.addToHomeIOSStep3),
      ],
    );
  }
}

class _AndroidBlock extends StatefulWidget {
  final bool expanded;
  const _AndroidBlock({required this.expanded});

  @override
  State<_AndroidBlock> createState() => _AndroidBlockState();
}

class _AndroidBlockState extends State<_AndroidBlock> {
  bool _installing = false;

  Future<void> _tryNativeInstall() async {
    if (!kIsWeb) return;
    setState(() => _installing = true);
    final ok = await PwaInstall.promptNativeInstall();
    if (!mounted) return;
    setState(() => _installing = false);
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return _PlatformExpansion(
      title: l.addToHomeAndroid,
      icon: Icons.phone_android,
      expanded: widget.expanded,
      children: [
        _stepBadge(1, l.addToHomeAndroidStep1),
        const AndroidMenuIllustration(),
        const SizedBox(height: 16),
        _stepBadge(2, l.addToHomeAndroidStep2),
        const AndroidInstallAppIllustration(),
        const SizedBox(height: 16),
        _stepBadge(3, l.addToHomeAndroidStep3),
        if (widget.expanded) ...[
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _installing ? null : _tryNativeInstall,
              icon: _installing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child:
                          CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.download_rounded, size: 16),
              label: Text(l.addToHomeButton),
            ),
          ),
        ],
      ],
    );
  }
}

class _DesktopBlock extends StatefulWidget {
  final bool expanded;
  const _DesktopBlock({required this.expanded});

  @override
  State<_DesktopBlock> createState() => _DesktopBlockState();
}

class _DesktopBlockState extends State<_DesktopBlock> {
  bool _installing = false;

  Future<void> _tryNativeInstall() async {
    if (!kIsWeb) return;
    setState(() => _installing = true);
    final ok = await PwaInstall.promptNativeInstall();
    if (!mounted) return;
    setState(() => _installing = false);
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return _PlatformExpansion(
      title: l.addToHomeDesktop,
      icon: Icons.desktop_windows_outlined,
      expanded: widget.expanded,
      children: [
        _stepBadge(1, l.addToHomeDesktopStep1),
        const DesktopInstallIllustration(),
        const SizedBox(height: 16),
        _stepBadge(2, l.addToHomeDesktopStep2),
        if (widget.expanded) ...[
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _installing ? null : _tryNativeInstall,
              icon: _installing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child:
                          CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.download_rounded, size: 16),
              label: Text(l.addToHomeButton),
            ),
          ),
        ],
      ],
    );
  }
}
