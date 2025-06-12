import 'package:flutter/material.dart';
import 'dart:math' as math;

class PremiumBackground extends StatefulWidget {
  const PremiumBackground({super.key});

  @override
  State<PremiumBackground> createState() => _PremiumBackgroundState();
}

class _PremiumBackgroundState extends State<PremiumBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                        const Color(0xFFF8FAFC),
                        const Color(0xFFEEF2FF),
                        (math.sin(_animation.value) + 1) / 2,
                      )!,
                      Color.lerp(
                        const Color(0xFFE0E7FF),
                        const Color(0xFFF3E8FF),
                        (math.cos(_animation.value * 0.8) + 1) / 2,
                      )!,
                    ],
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: OrbPainter(_animation.value),
                size: Size.infinite,
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.3, -0.3),
                radius: 1.2,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrbPainter extends CustomPainter {
  final double animationValue;
  static const List<OrbData> orbs = [
    OrbData(0.2, 0.3, 80, Color(0xFF3B82F6), 0.8),
    OrbData(0.8, 0.2, 60, Color(0xFF8B5CF6), 1.2),
    OrbData(0.1, 0.8, 100, Color(0xFF06B6D4), 0.6),
    OrbData(0.9, 0.7, 45, Color(0xFF10B981), 1.5),
    OrbData(0.6, 0.5, 70, Color(0xFFF59E0B), 0.9),
  ];

  OrbPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var orb in orbs) {
      final paint = Paint()
        ..color = orb.color.withOpacity(0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      final offsetX = math.sin(animationValue * orb.speed) * 15;
      final offsetY = math.cos(animationValue * orb.speed * 0.7) * 10;

      final center = Offset(
        orb.x * size.width + offsetX,
        orb.y * size.height + offsetY,
      );

      final pulseSize =
          orb.size * (0.9 + 0.1 * math.sin(animationValue * orb.speed * 2));

      canvas.drawCircle(center, pulseSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class OrbData {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double speed;

  const OrbData(this.x, this.y, this.size, this.color, this.speed);
}
