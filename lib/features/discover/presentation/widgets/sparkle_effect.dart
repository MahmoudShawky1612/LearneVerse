import 'dart:math';

import 'package:flutter/material.dart';

class Sparkles {
  final double animationValue;
  final double size;

  const Sparkles({required this.animationValue, required this.size});

  List<Widget> build() {
    final sparkleOpacity = (sin(animationValue * pi * 6) + 1) / 2;

    return [
      Positioned(
        top: -2,
        right: -2,
        child: Transform.rotate(
          angle: animationValue * pi * 2,
          child: Icon(
            Icons.star,
            color: Colors.amber.withOpacity(sparkleOpacity * 0.8),
            size: size * 0.3,
          ),
        ),
      ),
      Positioned(
        bottom: -1,
        left: -1,
        child: Transform.rotate(
          angle: -animationValue * pi * 1.5,
          child: Icon(
            Icons.star,
            color: Colors.pink.shade300.withOpacity(sparkleOpacity * 0.6),
            size: size * 0.25,
          ),
        ),
      ),
      Positioned(
        top: 0,
        left: -3,
        child: Transform.scale(
          scale: sparkleOpacity,
          child: Container(
            width: 3,
            height: 3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
      ),
    ];
  }
}
