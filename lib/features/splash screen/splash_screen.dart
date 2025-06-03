import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _textController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoSlideAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _taglineAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateParticles();
    _startAnimationSequence();

    // Navigate after 4 seconds to allow for full animation
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        context.pushReplacement('/user-selection');
      }
    });
  }

  void _initializeAnimations() {
    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Continuous rotation controller
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    // Pulse controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Particle controller
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Text controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );

    _logoSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // Text animations
    _textSlideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeInOut),
      ),
    );

    _taglineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Continuous animations
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.linear,
      ),
    );
  }

  void _generateParticles() {
    for (int i = 0; i < 20; i++) {
      _particles.add(Particle());
    }
  }

  void _startAnimationSequence() {
    _mainController.forward();
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    _particleController.repeat();

    Timer(const Duration(milliseconds: 800), () {
      if (mounted) _textController.forward();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF1e3c72),
              Color(0xFF0F0C29),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles background
            _buildParticlesBackground(),

            // Main content
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _mainController,
                  _textController,
                  _pulseController,
                  _rotationController,
                ]),
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated logo with multiple effects
                      _buildAnimatedLogo(),

                      SizedBox(height: 50.h),

                      // App name with slide and fade
                      _buildAnimatedTitle(),

                      SizedBox(height: 20.h),

                      // Tagline with delayed animation
                      _buildAnimatedTagline(),

                      SizedBox(height: 80.h),

                      // Modern loading indicator
                      _buildModernLoader(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticlesBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(_particles, _particleController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return Transform.translate(
      offset: Offset(0, _logoSlideAnimation.value),
      child: Opacity(
        opacity: _logoOpacityAnimation.value,
        child: Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing outer ring
              Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 2.w,
                    ),
                  ),
                ),
              ),

              // Rotating gradient ring
              Transform.rotate(
                angle: _rotationAnimation.value,
                child: Container(
                  width: 180.w,
                  height: 180.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.1, 0.2],
                    ),
                  ),
                ),
              ),

              // Main logo container with glassmorphism
              Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.15),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30.r,
                      offset: Offset(0, 15.h),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10.r,
                      offset: Offset(-5.w, -5.h),
                    ),
                  ],
                ),
                child: Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFFf093fb)],
                    ).createShader(bounds),
                    child: Icon(
                      Icons.school_rounded,
                      size: 80.r,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle() {
    return Transform.translate(
      offset: Offset(0, _textSlideAnimation.value),
      child: Opacity(
        opacity: _textOpacityAnimation.value,
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFf093fb),
              Colors.white,
            ],
            stops: [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: Text(
            'LearneVerse',
            style: TextStyle(
              fontSize: 48.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 2.0,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTagline() {
    return Opacity(
      opacity: _taglineAnimation.value,
      child: Transform.scale(
        scale: 0.8 + (_taglineAnimation.value * 0.2),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.w,
            ),
          ),
          child: Text(
            'Where Learning Meets Community',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 0.8,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernLoader() {
    return SizedBox(
      width: 50.w,
      height: 50.w,
      child: Stack(
        children: [
          // Background circle
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 3.w,
              ),
            ),
          ),
          // Animated progress circle
          Transform.rotate(
            angle: _rotationAnimation.value,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Colors.white.withOpacity(0.8),
              ),
              strokeWidth: 3.w,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late double size;
  late double opacity;
  late Color color;

  Particle() {
    reset();
  }

  void reset() {
    x = math.Random().nextDouble() * 400;
    y = math.Random().nextDouble() * 800;
    vx = (math.Random().nextDouble() - 0.5) * 2;
    vy = (math.Random().nextDouble() - 0.5) * 2;
    size = math.Random().nextDouble() * 3 + 1;
    opacity = math.Random().nextDouble() * 0.5 + 0.1;

    final colors = [
      Colors.white,
      const Color(0xFF667eea),
      const Color(0xFFf093fb),
      const Color(0xFF764ba2),
    ];
    color = colors[math.Random().nextInt(colors.length)];
  }

  void update() {
    x += vx;
    y += vy;

    if (x < 0 || x > 400 || y < 0 || y > 800) {
      reset();
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update();

      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}