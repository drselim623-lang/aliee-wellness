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
    // Arka plan katmanları Scaffold'un DIŞINDA: klavye açılınca Scaffold body
    // yeniden boyutlanır ama tam ekrana sabitlenen arka plan ve yapraklar
    // etkilenmez (aksi halde cover görseli yeniden kırpılıp "zıplıyordu").
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1) Sarmaşık arka plan
        const ColoredBox(color: AppColors.cream),
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

        // 4) Asıl içerik — şeffaf Scaffold, klavye sadece bunu etkiler
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: appBar,
          floatingActionButton: floatingActionButton,
          body: body,
        ),
      ],
    );
  }
}
