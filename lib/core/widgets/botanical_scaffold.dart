import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'floating_leaves.dart';

/// Aliee Wellness tüm uygulamada kullanılan ortak iskelet.
/// - `login_bg.png` arka planı tam ekran kaplar
/// - Yumuşak bir cream overlay arka planı yumuşatır (form içerikleri okunur kalsın)
/// - Süzülen yapraklar ekran üzerinde sonsuz dönüyor
/// - AppBar tamamen şeffaf, arka planın görünmesine izin verir
class BotanicalScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  /// Login dışı ekranlarda yaprakları biraz daha sönük tut.
  final double leafOpacity;

  /// Arka plan üzerine binen cream overlay'in opaklığı.
  /// 0 = sarmaşık çok belirgin, 1 = arka plan tamamen kapanır.
  /// Login için 0.0 (tam görünür), iç ekranlar için 0.55 önerilir.
  final double backgroundOverlay;

  const BotanicalScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.leafOpacity = 0.4,
    this.backgroundOverlay = 0.55,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Sarmaşık arka plan
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_bg.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          // 2) Cream overlay — içerik okunması için arka planı yumuşat
          if (backgroundOverlay > 0)
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: AppColors.cream.withValues(alpha: backgroundOverlay),
                ),
              ),
            ),

          // 3) Yapraklar
          FloatingLeaves(opacity: leafOpacity),

          // 4) Asıl içerik
          body,
        ],
      ),
    );
  }
}
