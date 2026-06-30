import 'dart:math' as math show pi, sin;

import 'package:flutter/material.dart';

/// Havada yavaşça süzülen şeffaf yapraklar (sonsuz döngü).
/// Tüm ekranı kaplar; hit-test'i engellemez (IgnorePointer).
class FloatingLeaves extends StatefulWidget {
  /// Yaprakların opaklığı (0..1). Sayfalarda formun okunmasını korumak için
  /// login ekranında daha yüksek (0.55), iç sayfalarda daha düşük (0.3) önerilir.
  final double opacity;

  const FloatingLeaves({super.key, this.opacity = 0.5});

  @override
  State<FloatingLeaves> createState() => _FloatingLeavesState();
}

class _FloatingLeavesState extends State<FloatingLeaves>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  late final List<_LeafSpec> _leaves = const [
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
    final t = ((_ctrl.value + leaf.phase) % 1.0);
    final yNorm = (t * leaf.verticalSpeed * 4) % 1.0;
    final y = -leaf.sizePx + yNorm * (size.height + leaf.sizePx * 2);

    final swing = math.sin(t * math.pi * 2) * leaf.amplitude;
    final x = (leaf.startX + swing).clamp(0.02, 0.95) * size.width -
        leaf.sizePx / 2;

    final rot = math.sin(t * math.pi * 2) * leaf.rotateAmplitude;

    return Positioned(
      left: x,
      top: y,
      child: Transform.rotate(
        angle: rot,
        child: Opacity(
          opacity: widget.opacity,
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
  final double startX;
  final double amplitude;
  final double verticalSpeed;
  final double rotateAmplitude;
  final double phase;

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
