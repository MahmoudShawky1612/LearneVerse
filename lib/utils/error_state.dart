import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class ErrorStateWidget extends StatefulWidget {
  final String title;
  final Function onRetry;
  final String buttonText;
  final String message;

  const ErrorStateWidget({
    super.key,
    this.title = 'Oops! Something Broke!',
    required this.onRetry,
    this.buttonText = 'Let\'s Try Again',
    this.message =
        'We encountered an unexpected error. Please try again later.',
  });

  @override
  _ErrorStateWidgetState createState() => _ErrorStateWidgetState();
}

class _ErrorStateWidgetState extends State<ErrorStateWidget>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;
  late AnimationController _buttonController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _buttonScaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _lottieController, curve: Curves.easeInOut),
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _lottieController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _buttonController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _buttonController.reverse();
    widget.onRetry();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _buttonController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lottie Animation with Scale Effect
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                    child: SizedBox(
                      height: 200.h,
                      child: Lottie.network(
                        'https://lottie.host/1cee61dc-e2e2-4b1e-aa52-70cfa78d29fb/qUjr4QtI0R.json',
                        fit: BoxFit.contain,
                        repeat: true,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.error_outline,
                            size: 48.sp,
                            color: theme.colorScheme.error,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Title
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),

                  // Message
                  Text(
                    widget.message,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 24.h),

                  // Modern Retry Button
                  GestureDetector(
                    onTapDown: _onTapDown,
                    onTapUp: _onTapUp,
                    onTapCancel: _onTapCancel,
                    child: AnimatedBuilder(
                      animation: _buttonScaleAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _buttonScaleAnimation.value,
                        child: Container(
                          height: 48.h,
                          constraints: BoxConstraints(minWidth: 140.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.3),
                                blurRadius: 12.r,
                                offset: Offset(0, 4.h),
                                spreadRadius: 0,
                              ),
                              if (_isPressed)
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.2),
                                  blurRadius: 6.r,
                                  offset: Offset(0, 2.h),
                                  spreadRadius: 0,
                                ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 18.sp,
                                  color: theme.colorScheme.onPrimary,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  widget.buttonText,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimary,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100.h,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
