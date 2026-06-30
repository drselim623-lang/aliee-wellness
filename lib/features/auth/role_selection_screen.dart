import 'dart:math' as math show pi, sin;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_theme.dart';
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Sarmaşık arka planı — tüm ekranı kaplar
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_bg.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          // Süzülen yapraklar (sürekli animasyon)
          const _FloatingLeaves(),

          // İçerik — entrance fade + slide
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
                        // Logo (leaf_3 — yarım daire yaprak kompozisyonu)
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
                            style:
                                Theme.of(context).textTheme.displaySmall?.copyWith(
                                      letterSpacing: 0.5,
                                    ),
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
                        // Kart — form arka plan kontrastı için
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

          // Doktor girişi — sağ üst köşe
          Positioned(
            right: 8,
            top: MediaQuery.of(context).padding.top + 4,
            child: FadeTransition(
              opacity: _fade,
              child: IconButton(
                tooltip: l.doctorLogin,
                onPressed: () => context.push(AppRoutes.doctorLogin),
                icon: const Icon(Icons.medical_services_outlined,
                    color: AppColors.sageDark),
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

/// Birkaç yaprağı havada yavaşça döndüren + süzdüren widget.
class _FloatingLeaves extends StatefulWidget {
  const _FloatingLeaves();

  @override
  State<_FloatingLeaves> createState() => _FloatingLeavesState();
}

class _FloatingLeavesState extends State<_FloatingLeaves>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  late final List<_LeafSpec> _leaves = [
    _LeafSpec(
      asset: 'assets/images/leaf_1.png',
      sizePx: 64,
      startX: 0.18,
      amplitude: 0.06,
      verticalSpeed: 0.18,
      rotateAmplitude: 0.12,
      phase: 0,
    ),
    _LeafSpec(
      asset: 'assets/images/leaf_2.png',
      sizePx: 52,
      startX: 0.72,
      amplitude: 0.08,
      verticalSpeed: 0.13,
      rotateAmplitude: 0.18,
      phase: 0.35,
    ),
    _LeafSpec(
      asset: 'assets/images/leaf_1.png',
      sizePx: 38,
      startX: 0.5,
      amplitude: 0.1,
      verticalSpeed: 0.22,
      rotateAmplitude: 0.2,
      phase: 0.7,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return Stack(
            children: [
              for (final leaf in _leaves) _build(leaf, size),
            ],
          );
        },
      ),
    );
  }

  Widget _build(_LeafSpec leaf, Size size) {
    // 0..1 arası periyodik t (her yaprağın kendi fazı var)
    final t = ((_ctrl.value + leaf.phase) % 1.0);
    // Yavaşça aşağıya iniyor + ekran üstünden tekrar başlıyor
    final yNorm = (t * leaf.verticalSpeed * 4) % 1.0;
    final y = -leaf.sizePx + yNorm * (size.height + leaf.sizePx * 2);

    // Yatayda sinüs salınım
    final swing = math.sin(t * math.pi * 2) * leaf.amplitude;
    final x = (leaf.startX + swing).clamp(0.02, 0.95) * size.width -
        leaf.sizePx / 2;

    // Dönme
    final rot = math.sin(t * math.pi * 2) * leaf.rotateAmplitude;

    return Positioned(
      left: x,
      top: y,
      child: Transform.rotate(
        angle: rot,
        child: Opacity(
          opacity: 0.55,
          child: Image.asset(
            leaf.asset,
            width: leaf.sizePx,
            height: leaf.sizePx,
          ),
        ),
      ),
    );
  }
}

class _LeafSpec {
  final String asset;
  final double sizePx;
  final double startX;       // 0..1 — yatay başlangıç
  final double amplitude;    // 0..1 — yatay salınım genişliği
  final double verticalSpeed;
  final double rotateAmplitude;
  final double phase;        // 0..1 — başlangıç ofseti

  const _LeafSpec({
    required this.asset,
    required this.sizePx,
    required this.startX,
    required this.amplitude,
    required this.verticalSpeed,
    required this.rotateAmplitude,
    required this.phase,
  });
}
