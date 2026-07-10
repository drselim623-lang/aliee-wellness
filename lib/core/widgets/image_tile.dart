import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Tıklanabilir görsel kart.
/// - Arka planda asset görseli (BoxFit.cover)
/// - Altta koyu degrade üzerine başlık (+ opsiyonel açıklama)
/// - Görsel henüz assets'e eklenmemişse sage degrade + ikon gösterir,
///   böylece eksik görsel uygulamayı bozmaz.
class ImageTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? subtitle;
  final IconData fallbackIcon;
  final VoidCallback? onTap;

  const ImageTile({
    super.key,
    required this.imagePath,
    required this.title,
    this.subtitle,
    this.fallbackIcon = Icons.spa_outlined,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.sage, AppColors.sageDark],
                ),
              ),
              child: Center(
                child: Icon(
                  fallbackIcon,
                  color: Colors.white.withValues(alpha: 0.85),
                  size: 40,
                ),
              ),
            ),
          ),
          // Alt degrade — başlık her görsel üzerinde okunur kalsın
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.ink.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 12,
            child: IgnorePointer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.2,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(onTap: onTap),
          ),
        ],
      ),
    );
  }
}
