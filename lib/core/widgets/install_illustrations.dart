import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// iOS Safari — alt bar simülasyonu, Paylaş butonu vurgulanmış.
class IOSShareIllustration extends StatelessWidget {
  const IOSShareIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return _BrowserFrame(
      isBottom: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _dimBtn(Icons.arrow_back_ios_new_rounded),
          _dimBtn(Icons.arrow_forward_ios_rounded),
          _HighlightedButton(icon: Icons.ios_share_rounded),
          _dimBtn(Icons.book_outlined),
          _dimBtn(Icons.tab_outlined),
        ],
      ),
    );
  }
}

/// iOS Safari — paylaş menüsünde "Add to Home Screen" satırı vurgulanmış.
class IOSAddToHomeIllustration extends StatelessWidget {
  const IOSAddToHomeIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return _BrowserFrame(
      isBottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuRow(Icons.copy_outlined, 'Copy', dim: true),
            _menuRow(Icons.bookmark_add_outlined, 'Add Bookmark', dim: true),
            _HighlightedMenuRow(
              icon: Icons.add_box_outlined,
              label: 'Add to Home Screen',
            ),
            _menuRow(Icons.mail_outline_rounded, 'Mail', dim: true),
          ],
        ),
      ),
    );
  }
}

/// Android Chrome — üst çubuk + ⋮ menü butonu vurgulanmış.
class AndroidMenuIllustration extends StatelessWidget {
  const AndroidMenuIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return _BrowserFrame(
      isBottom: false,
      showUrl: true,
      trailing: const _HighlightedButton(icon: Icons.more_vert),
    );
  }
}

/// Android Chrome — açılan menüde "Install app" satırı vurgulanmış.
class AndroidInstallAppIllustration extends StatelessWidget {
  const AndroidInstallAppIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return _BrowserFrame(
      isBottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuRow(Icons.history_rounded, 'History', dim: true),
            _menuRow(Icons.download_outlined, 'Downloads', dim: true),
            _HighlightedMenuRow(
              icon: Icons.install_mobile_outlined,
              label: 'Install app',
            ),
            _menuRow(Icons.settings_outlined, 'Settings', dim: true),
          ],
        ),
      ),
    );
  }
}

/// Desktop Chrome/Edge — URL çubuğunun sağındaki install ikonu vurgulanmış.
class DesktopInstallIllustration extends StatelessWidget {
  const DesktopInstallIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return _BrowserFrame(
      isBottom: false,
      showUrl: true,
      trailingRow: [
        const _HighlightedButton(icon: Icons.install_desktop),
        const SizedBox(width: 6),
        _dimBtn(Icons.person_outline),
        const SizedBox(width: 6),
        _dimBtn(Icons.more_vert),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Ortak parçalar
// -----------------------------------------------------------------------------

class _BrowserFrame extends StatelessWidget {
  final Widget? child;
  final bool isBottom; // alt bar hissi için
  final bool showUrl;
  final Widget? trailing;
  final List<Widget>? trailingRow;

  const _BrowserFrame({
    this.child,
    this.isBottom = false,
    this.showUrl = false,
    this.trailing,
    this.trailingRow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColors.creamSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isBottom)
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  if (showUrl)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.lock_outline,
                                size: 12, color: AppColors.inkSoft),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'aliee-wellness.web.app',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.inkSoft,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (trailingRow != null) ...[
                    const SizedBox(width: 8),
                    ...trailingRow!,
                  ] else if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              ),
            ),
          if (child != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: child!,
            ),
          if (isBottom)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: child ?? const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}

Widget _dimBtn(IconData icon) => Padding(
      padding: const EdgeInsets.all(6),
      child: Icon(icon, color: AppColors.inkSoft.withValues(alpha: 0.55), size: 20),
    );

Widget _menuRow(IconData icon, String label, {bool dim = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    child: Row(
      children: [
        Icon(icon,
            color: dim
                ? AppColors.inkSoft.withValues(alpha: 0.4)
                : AppColors.inkSoft,
            size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: dim
                ? AppColors.inkSoft.withValues(alpha: 0.55)
                : AppColors.ink,
          ),
        ),
      ],
    ),
  );
}

/// Kırmızı halka + parlayan efekt ile vurgulanmış tıklanacak buton.
class _HighlightedButton extends StatelessWidget {
  final IconData icon;
  const _HighlightedButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.terracotta.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.terracotta, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.terracotta.withValues(alpha: 0.35),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.terracotta, size: 20),
    );
  }
}

class _HighlightedMenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HighlightedMenuRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.terracotta.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.terracotta, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.terracotta.withValues(alpha: 0.25),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.terracotta, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.terracotta,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          const Icon(Icons.touch_app_outlined,
              color: AppColors.terracotta, size: 18),
        ],
      ),
    );
  }
}
