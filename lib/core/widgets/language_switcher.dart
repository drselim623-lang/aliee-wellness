import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../locale/locale_provider.dart';
import '../theme/app_theme.dart';

/// Kullanıcının uygulama dilini değiştirebileceği ikon buton.
/// AppBar action olarak veya rol seçim ekranının üstünde kullanılabilir.
class LanguageSwitcherButton extends ConsumerWidget {
  final Color? iconColor;
  const LanguageSwitcherButton({super.key, this.iconColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return IconButton(
      tooltip: AppL10n.of(context).language,
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language, color: iconColor ?? AppColors.sageDark),
          const SizedBox(width: 4),
          Text(
            locale.languageCode.toUpperCase(),
            style: TextStyle(
              color: iconColor ?? AppColors.sageDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      onPressed: () => _open(context, ref),
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    final current = ref.read(localeProvider);
    final picked = await showModalBottomSheet<Locale>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                AppL10n.of(context).language,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            for (final l in kSupportedLocales)
              ListTile(
                title: Text(
                  kLanguageNames[l.languageCode] ?? l.languageCode,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: current.languageCode == l.languageCode
                    ? const Icon(Icons.check, color: AppColors.sageDark)
                    : null,
                onTap: () => Navigator.of(context).pop(l),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (picked != null) {
      await ref.read(localeProvider.notifier).set(picked);
    }
  }
}
