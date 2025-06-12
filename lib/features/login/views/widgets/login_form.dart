import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PremiumLoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final VoidCallback onPasswordVisibilityToggle;
  final Future<void> Function() onLoginPressed;
  final Animation<double> breathingAnimation;

  const PremiumLoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onPasswordVisibilityToggle,
    required this.onLoginPressed,
    required this.breathingAnimation,
  });

  @override
  State<PremiumLoginForm> createState() => _PremiumLoginFormState();
}

class _PremiumLoginFormState extends State<PremiumLoginForm>
    with TickerProviderStateMixin {
  late AnimationController _buttonController;
  late AnimationController _fieldController;
  late Animation<double> _buttonScale;
  late Animation<double> _fieldFocus;

  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fieldController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _fieldFocus = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fieldController, curve: Curves.easeOut),
    );

    widget.emailController.addListener(_validateEmail);
    widget.passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    widget.emailController.removeListener(_validateEmail);
    widget.passwordController.removeListener(_validatePassword);
    _buttonController.dispose();
    _fieldController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = widget.emailController.text;
    final isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    if (isValid != _isEmailValid) {
      setState(() => _isEmailValid = isValid);
      if (isValid) HapticFeedback.selectionClick();
    }
  }

  void _validatePassword() {
    final password = widget.passwordController.text;
    final isValid = password.length >= 6;
    if (isValid != _isPasswordValid) {
      setState(() => _isPasswordValid = isValid);
      if (isValid) HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          _buildPremiumInputField(
            label: 'Email Address',
            controller: widget.emailController,
            icon: Icons.alternate_email_rounded,
            isObscure: false,
            isFocused: _isEmailFocused,
            isValid: _isEmailValid,
            onFocusChange: (focused) {
              setState(() => _isEmailFocused = focused);
              if (focused) {
                _fieldController.forward();
                HapticFeedback.selectionClick();
              } else {
                _fieldController.reverse();
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          _buildPremiumInputField(
            label: 'Password',
            controller: widget.passwordController,
            icon: Icons.lock_outline_rounded,
            isObscure: !widget.isPasswordVisible,
            isFocused: _isPasswordFocused,
            isValid: _isPasswordValid,
            onFocusChange: (focused) {
              setState(() => _isPasswordFocused = focused);
              if (focused) {
                _fieldController.forward();
                HapticFeedback.selectionClick();
              } else {
                _fieldController.reverse();
              }
            },
            suffixIcon: GestureDetector(
              onTap: widget.onPasswordVisibilityToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(12.r),
                child: Icon(
                  widget.isPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: widget.isPasswordVisible
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF6B7280),
                  size: 20.r,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFF3B82F6).withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          AnimatedBuilder(
            animation:
                Listenable.merge([_buttonScale, widget.breathingAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _buttonScale.value * widget.breathingAnimation.value,
                child: GestureDetector(
                  onTapDown: (_) {
                    _buttonController.forward();
                    HapticFeedback.mediumImpact();
                  },
                  onTapUp: (_) => _buttonController.reverse(),
                  onTapCancel: () => _buttonController.reverse(),
                  onTap: widget.isLoading ? null : widget.onLoginPressed,
                  child: Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: widget.isLoading
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF9CA3AF),
                                Color(0xFF6B7280),
                              ],
                            )
                          : const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF3B82F6),
                                Color(0xFF8B5CF6),
                                Color(0xFF06B6D4),
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.4),
                          blurRadius: 20.r,
                          offset: Offset(0, 8.h),
                          spreadRadius: -2.r,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 8.r,
                          offset: Offset(-2.w, -2.h),
                          spreadRadius: -1.r,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (!widget.isLoading)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: AnimatedBuilder(
                                animation: widget.breathingAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      (widget.breathingAnimation.value - 0.5) *
                                          200.w,
                                      0,
                                    ),
                                    child: Container(
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.white.withOpacity(0.3),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        widget.isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Signing In...',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.login_rounded,
                                    color: Colors.white,
                                    size: 20.r,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isObscure,
    required bool isFocused,
    required bool isValid,
    required Function(bool) onFocusChange,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color:
                  isFocused ? const Color(0xFF3B82F6) : const Color(0xFF374151),
              letterSpacing: 0.3,
            ),
          ),
        ),
        Focus(
          onFocusChange: onFocusChange,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isFocused
                    ? [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.7),
                      ]
                    : [
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.5),
                      ],
              ),
              border: Border.all(
                color: isFocused
                    ? const Color(0xFF3B82F6)
                    : isValid
                        ? const Color(0xFF10B981)
                        : Colors.white.withOpacity(0.3),
                width: isFocused ? 2.0 : 1.5,
              ),
              boxShadow: [
                if (isFocused)
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.2),
                    blurRadius: 20.r,
                    offset: Offset(0, 4.h),
                    spreadRadius: -2.r,
                  ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isObscure,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF1F2937),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your ${label.toLowerCase()}',
                hintStyle: TextStyle(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      icon,
                      color: isFocused
                          ? const Color(0xFF3B82F6)
                          : isValid
                              ? const Color(0xFF10B981)
                              : const Color(0xFF9CA3AF),
                      size: 20.r,
                    ),
                  ),
                ),
                suffixIcon: suffixIcon != null
                    ? Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: suffixIcon,
                      )
                    : isValid
                        ? Padding(
                            padding: EdgeInsets.all(12.r),
                            child: Icon(
                              Icons.check_circle_rounded,
                              color: const Color(0xFF10B981),
                              size: 20.r,
                            ),
                          )
                        : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
              ),
              validator: validator,
              onChanged: (value) {
                if (label.contains('Email')) {
                  _validateEmail();
                } else {
                  _validatePassword();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
