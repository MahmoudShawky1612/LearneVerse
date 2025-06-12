import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PremiumLoginHeader extends StatelessWidget {
  final Animation<double> floatingAnimation;
  final Animation<double> rotationAnimation;
  final AnimationController iconController;
  final Animation<double> iconScale;

  const PremiumLoginHeader({
    Key? key,
    required this.floatingAnimation,
    required this.rotationAnimation,
    required this.iconController,
    required this.iconScale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: iconController,
          builder: (context, child) {
            return Transform.scale(
              scale: iconScale.value,
              child: Container(
                width: 150,
                height: 150,

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Lottie.network(
                    'https://lottie.host/2213c81c-5105-4a93-bc1d-9c4566ae9e04/NxMGPzPgQZ.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Colors.purple, // Slate 900
              Colors.deepPurple, // Slate 700
              Colors.blueAccent, // Slate 600
                Colors.lightBlueAccent, // Slate 800
             ],
          ).createShader(bounds),
          child: const Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.8,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Continue where you left off',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF64748B),
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
