import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class PremiumLoginHeader extends StatelessWidget {
  final Animation<double> floatingAnimation;
  final Animation<double> rotationAnimation;

  const PremiumLoginHeader({
    super.key,
    required this.floatingAnimation,
    required this.rotationAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animated logo container with multiple layers
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Transform.rotate(
              angle: rotationAnimation.value * 2 * math.pi,
              child: Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF3B82F6).withOpacity(0.1),
                      const Color(0xFF8B5CF6).withOpacity(0.1),
                      const Color(0xFF06B6D4).withOpacity(0.1),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Middle pulsing ring
            Transform.scale(
              scale: 1.0 + (floatingAnimation.value * 0.05),
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF3B82F6).withOpacity(0.15),
                      const Color(0xFF8B5CF6).withOpacity(0.15),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.2),
                      blurRadius: 20.r,
                      spreadRadius: 2.r,
                    ),
                  ],
                ),
              ),
            ),

            // Main logo container
            Transform.translate(
              offset: Offset(0, math.sin(floatingAnimation.value * 2 * math.pi) * 3),
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3B82F6),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.4),
                      blurRadius: 25.r,
                      offset: Offset(0, 10.h),
                      spreadRadius: -5.r,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.9),
                      blurRadius: 10.r,
                      offset: Offset(-5.w, -5.h),
                      spreadRadius: -2.r,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Inner glow
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Main icon
                    Transform.scale(
                      scale: 1.0 + (floatingAnimation.value * 0.03),
                      child: Icon(
                        Icons.school_rounded,
                        size: 45.r,
                        color: Colors.white,
                      ),
                    ),

                    // Sparkle effects
                    ...List.generate(6, (index) {
                      final angle = (index * 60) * (math.pi / 180);
                      final radius = 35.r;
                      return Transform.translate(
                        offset: Offset(
                          math.cos(angle + rotationAnimation.value * 2 * math.pi) * radius,
                          math.sin(angle + rotationAnimation.value * 2 * math.pi) * radius,
                        ),
                        child: Transform.scale(
                          scale: 0.5 + (math.sin(floatingAnimation.value * 4 * math.pi + index) * 0.3),
                          child: Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.6),
                                  blurRadius: 8.r,
                                  spreadRadius: 2.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 24.h),

        // App name with gradient text
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFF3B82F6),
              Color(0xFF8B5CF6),
              Color(0xFF06B6D4),
            ],
            stops: [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: Text(
            'LearneVerse',
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 2.h),
                  blurRadius: 4.r,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 8.h),

        // Tagline with typing effect
        AnimatedBuilder(
          animation: floatingAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, math.sin(floatingAnimation.value * 2 * math.pi + math.pi) * 2),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Elevate Your Learning Journey',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF1F2937),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 16.h),

        // Premium welcome text
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Welcome ',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF374151),
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Back',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF3B82F6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 4.h),

        // Subtitle with premium styling
        Text(
          'Sign in to continue your learning adventure',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}