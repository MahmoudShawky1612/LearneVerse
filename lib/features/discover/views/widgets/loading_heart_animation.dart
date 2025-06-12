import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/discover/views/widgets/sparkle_effect.dart';

class LoadingHeartAnimation extends StatelessWidget {
  final double size;

  const LoadingHeartAnimation({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        // Create a pulsing scale effect
        final scale = 1.0 + (sin(value * pi * 4) * 0.15);

        // Create color transition from red to transparent
        final colorProgress = (sin(value * pi * 2) + 1) / 2;
        final heartColor = Color.lerp(
          Colors.red.shade400,
          Colors.red.shade400.withOpacity(0.2),
          colorProgress,
        );

        // Create fill transition effect
        final fillProgress = (cos(value * pi * 3) + 1) / 2;

        return Transform.scale(
          scale: scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background heart (always visible, subtle)
              Icon(
                Icons.favorite_border,
                color: Colors.red.shade300.withOpacity(0.3),
                size: size,
              ),

              ClipPath(
                clipper: _HeartFillClipper(fillProgress),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        heartColor ?? Colors.red.shade400,
                        (heartColor ?? Colors.red.shade400).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: size,
                  ),
                ),
              ),

              // Sparkle effects
              if (fillProgress > 0.7)
                ...Sparkles(animationValue: value, size: size).build(),
            ],
          ),
        );
      },
    );
  }
}

class _HeartFillClipper extends CustomClipper<Path> {
  final double fillLevel;

  _HeartFillClipper(this.fillLevel);

  @override
  Path getClip(Size size) {
    final path = Path();
    final fillHeight = size.height * (1.0 - fillLevel);

    path.addRect(
      Rect.fromLTWH(0, fillHeight, size.width, size.height - fillHeight),
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
