import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnhancedVoteButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isUpvote;
  final bool isLoading;

  const EnhancedVoteButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isUpvote,
    required this.isLoading,
  });

  @override
  State<EnhancedVoteButton> createState() => _EnhancedVoteButtonState();
}

class _EnhancedVoteButtonState extends State<EnhancedVoteButton>
    with TickerProviderStateMixin {
  late AnimationController _upvoteController;
  late AnimationController _downvoteController;
  late AnimationController _upvotePulseController;
  late AnimationController _downvotePulseController;
  late AnimationController _upvoteFloatController;
  late AnimationController _downvoteFloatController;

  late Animation<double> _upvoteScaleAnimation;
  late Animation<double> _downvoteScaleAnimation;
  late Animation<double> _upvoteRotationAnimation;
  late Animation<double> _downvoteRotationAnimation;
  late Animation<double> _upvotePulseAnimation;
  late Animation<double> _downvotePulseAnimation;
  late Animation<double> _upvoteFloatAnimation;
  late Animation<double> _downvoteFloatAnimation;
  late Animation<Color?> _upvoteColorAnimation;
  late Animation<Color?> _downvoteColorAnimation;

  @override
  void initState() {
    super.initState();

    _upvoteController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _downvoteController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _upvotePulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _downvotePulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _upvoteFloatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _downvoteFloatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _initializeAnimations();
  }

  void _initializeAnimations() {
    _upvoteScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(
      parent: _upvoteController,
      curve: Curves.elasticOut,
    ));

    _downvoteScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(
      parent: _downvoteController,
      curve: Curves.elasticOut,
    ));

    _upvoteRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _upvoteController,
      curve: Curves.easeOutBack,
    ));

    _downvoteRotationAnimation = Tween<double>(
      begin: 0.0,
      end: -0.5,
    ).animate(CurvedAnimation(
      parent: _downvoteController,
      curve: Curves.easeOutBack,
    ));

    _upvotePulseAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _upvotePulseController,
      curve: Curves.easeOut,
    ));

    _downvotePulseAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _downvotePulseController,
      curve: Curves.easeOut,
    ));

    _upvoteFloatAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _upvoteFloatController,
      curve: Curves.easeOutQuart,
    ));

    _downvoteFloatAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _downvoteFloatController,
      curve: Curves.easeOutQuart,
    ));

    _upvoteColorAnimation = ColorTween(
      begin: const Color(0xFF00E676),
      end: const Color(0xFF76FF03),
    ).animate(_upvoteController);

    _downvoteColorAnimation = ColorTween(
      begin: const Color(0xFFFF1744),
      end: const Color(0xFFFF5722),
    ).animate(_downvoteController);
  }

  @override
  void dispose() {
    _upvoteController.dispose();
    _downvoteController.dispose();
    _upvotePulseController.dispose();
    _downvotePulseController.dispose();
    _upvoteFloatController.dispose();
    _downvoteFloatController.dispose();
    super.dispose();
  }
  bool _isActivated = false; // new field

  @override
  Widget build(BuildContext context) {

    final scaleAnimation =
    widget.isUpvote ? _upvoteScaleAnimation : _downvoteScaleAnimation;
    final rotationAnimation =
    widget.isUpvote ? _upvoteRotationAnimation : _downvoteRotationAnimation;
    final pulseAnimation =
    widget.isUpvote ? _upvotePulseAnimation : _downvotePulseAnimation;
    final floatAnimation =
    widget.isUpvote ? _upvoteFloatAnimation : _downvoteFloatAnimation;
    final colorAnimation =
    widget.isUpvote ? _upvoteColorAnimation : _downvoteColorAnimation;

    return GestureDetector(
      onTap: widget.isLoading
          ? null
          : () {
        setState(() => _isActivated = !_isActivated); // toggle state
        widget.onTap();

        if (widget.isUpvote) {
          _isActivated
              ? _upvoteController.forward(from: 0)
              : _upvoteController.reverse();
          _upvotePulseController.forward(from: 0);
        } else {
          _isActivated
              ? _downvoteController.forward(from: 0)
              : _downvoteController.reverse();
          _downvotePulseController.forward(from: 0);
        }
      },

      child: SizedBox(
        width: 32.w,
        height: 32.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.isLoading)
              AnimatedBuilder(
                animation: pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: pulseAnimation.value * 16.w,
                    height: pulseAnimation.value * 16.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.color,
                        width: 2.w,
                      ),
                    ),
                  );
                },
              ),
            AnimatedBuilder(
              animation: scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: scaleAnimation.value,
                  child: Transform.rotate(
                    angle: rotationAnimation.value,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (widget.color != Colors.grey
                            ? colorAnimation.value
                            : widget.color)
                            ?.withOpacity(0.1),
                        boxShadow: widget.color != Colors.grey
                            ? [
                          BoxShadow(
                            color: (colorAnimation.value ?? widget.color)
                                .withOpacity(0.4),
                            blurRadius: 8.r,
                            spreadRadius: 2.r,
                          ),
                        ]
                            : null,
                      ),
                      child: Icon(
                        widget.icon,
                        size: 15.r,
                        color: colorAnimation.value ?? widget.color,
                      ),
                    ),
                  ),
                );
              },
            ),
            if (widget.isLoading)
              AnimatedBuilder(
                animation: floatAnimation,
                builder: (context, child) {
                  final animationValue = floatAnimation.value;
                  return Stack(
                    children: List.generate(6, (index) {
                      final angle = (index * math.pi / 3) +
                          (animationValue * math.pi * 2);
                      final distance = animationValue * 20.w;
                      final opacity = (1.0 - animationValue).clamp(0.0, 1.0);
                      final sparkleSize = 3.w +
                          (math.sin(animationValue * math.pi * 4) * 2.w);

                      return Positioned(
                        left: 16.w + (distance * math.cos(angle)),
                        top: 16.h + (distance * math.sin(angle)),
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: sparkleSize.abs(),
                            height: sparkleSize.abs(),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  widget.color.withOpacity(0.8),
                                  widget.color.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
