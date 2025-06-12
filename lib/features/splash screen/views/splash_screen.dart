import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/token_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFloatAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _dotsAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _checkAuth(context);
      }
    });
  }

  Future<void> _checkAuth(BuildContext context) async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      context.pushReplacement('/');
    } else {
      context.pushReplacement('/login');
    }
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _logoFloatAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
    ));

    _textSlideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
    ));

    _dotsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ));
  }

  void _startAnimations() {
    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: AnimatedBuilder(
        animation: Listenable.merge([_mainController, _floatController]),
        builder: (context, child) {
          return Stack(
            children: [
              _buildBackgroundDecoration(),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFloatingLogo(),
                    SizedBox(height: 30.h),
                    _buildAnimatedTitle(),
                    SizedBox(height: 12.h),
                    _buildTagline(),
                    SizedBox(height: 50.h),
                    _buildLoadingDots(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackgroundDecoration() {
    return Positioned.fill(
      child: CustomPaint(
        painter: MinimalBackgroundPainter(
          animationValue: _floatController.value,
        ),
      ),
    );
  }

  Widget _buildFloatingLogo() {
    return Transform.translate(
      offset: Offset(0, -_logoFloatAnimation.value),
      child: Transform.scale(
        scale: _logoScaleAnimation.value,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 40.r,
                    spreadRadius: 10.r,
                  ),
                ],
              ),
            ),
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5.w,
                ),
              ),
              child: Icon(
                Icons.school_rounded,
                size: 50.r,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle() {
    return Transform.translate(
      offset: Offset(0, _textSlideAnimation.value),
      child: Opacity(
        opacity: _fadeInAnimation.value,
        child: Text(
          'LearneVerse',
          style: TextStyle(
            fontSize: 36.sp,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            letterSpacing: 4.0,
            shadows: [
              Shadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 20.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return Opacity(
      opacity: _fadeInAnimation.value * 0.7,
      child: Text(
        'Learn • Connect • Grow',
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.white.withOpacity(0.6),
          fontWeight: FontWeight.w400,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return Opacity(
      opacity: _dotsAnimation.value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final delay = index * 0.3;
          final dotAnimation = Tween<double>(
            begin: 0.3,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: _floatController,
            curve: Interval(delay, 1.0, curve: Curves.easeInOut),
          ));

          return AnimatedBuilder(
            animation: dotAnimation,
            builder: (context, child) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(dotAnimation.value * 0.8),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class MinimalBackgroundPainter extends CustomPainter {
  final double animationValue;

  MinimalBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 3; i++) {
      final radius = 150.0 + (i * 80) + (animationValue * 20);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
