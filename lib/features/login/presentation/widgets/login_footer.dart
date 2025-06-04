import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class PremiumLoginFooter extends StatefulWidget {
  final Animation<double> floatingAnimation;

  const PremiumLoginFooter({
    super.key,
    required this.floatingAnimation,
  });

  @override
  State<PremiumLoginFooter> createState() => _PremiumLoginFooterState();
}

class _PremiumLoginFooterState extends State<PremiumLoginFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverScale;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        AnimatedBuilder(
          animation: widget.floatingAnimation,
          builder: (context, child) {
            return Container(
              height: 1.h,
              margin: EdgeInsets.symmetric(vertical: 24.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFF3B82F6).withOpacity(
                        0.3 + widget.floatingAnimation.value * 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            );
          },
        ),

        
        Text(
          'Or continue with',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),

        SizedBox(height: 20.h),

        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(
              icon: Icons.g_mobiledata_rounded,
              label: 'Google',
              colors: [const Color(0xFF4285F4), const Color(0xFF34A853)],
              onTap: () {
                HapticFeedback.selectionClick();
                
              },
            ),
            _buildSocialButton(
              icon: Icons.apple_rounded,
              label: 'Apple',
              colors: [const Color(0xFF000000), const Color(0xFF333333)],
              onTap: () {
                HapticFeedback.selectionClick();
                
              },
            ),
            _buildSocialButton(
              icon: Icons.facebook_rounded,
              label: 'Facebook',
              colors: [const Color(0xFF1877F2), const Color(0xFF42A5F5)],
              onTap: () {
                HapticFeedback.selectionClick();
                
              },
            ),
          ],
        ),

        SizedBox(height: 32.h),

        
        AnimatedBuilder(
          animation: Listenable.merge([widget.floatingAnimation, _hoverScale]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                  0,
                  math.sin(widget.floatingAnimation.value * 2 * math.pi +
                          math.pi / 2) *
                      2),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                    MouseRegion(
                      onEnter: (_) {
                        setState(() => _isHovered = true);
                        _hoverController.forward();
                      },
                      onExit: (_) {
                        setState(() => _isHovered = false);
                        _hoverController.reverse();
                      },
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          
                        },
                        child: Transform.scale(
                          scale: _hoverScale.value,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF3B82F6)
                                      .withOpacity(_isHovered ? 0.2 : 0.1),
                                  const Color(0xFF8B5CF6)
                                      .withOpacity(_isHovered ? 0.2 : 0.1),
                                ],
                              ),
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF3B82F6),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        SizedBox(height: 24.h),

        
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              'By signing in, you agree to our ',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF9CA3AF),
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                
              },
              child: Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF3B82F6),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Text(
              ' and ',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF9CA3AF),
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                
              },
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF3B82F6),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: widget.floatingAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 +
                (math.sin(widget.floatingAnimation.value * 2 * math.pi) * 0.02),
            child: Container(
              width: 80.w,
              height: 48.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.7),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10.r,
                    offset: Offset(0, 2.h),
                  ),
                  BoxShadow(
                    color: colors.first.withOpacity(0.1),
                    blurRadius: 8.r,
                    offset: Offset(0, 1.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: colors,
                    ).createShader(bounds),
                    child: Icon(
                      icon,
                      size: 20.r,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
