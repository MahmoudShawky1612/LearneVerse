import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../../logic/cubit/auth_state.dart';
import '../widgets/background.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';
import '../widgets/snackbar.dart';

class PremiumLoginScreen extends StatefulWidget {
  const PremiumLoginScreen({super.key});

  @override
  State<PremiumLoginScreen> createState() => _PremiumLoginScreenState();
}

class _PremiumLoginScreenState extends State<PremiumLoginScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late AnimationController _particleController;
  late AnimationController _breathingController;

  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _rotationAnimation;

  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isInitialAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );

    
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutExpo),
      ),
    );

    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );

    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    
    _floatingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _floatingController,
        curve: Curves.easeInOut,
      ),
    );

    
    _breathingAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );

    
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.linear,
      ),
    );
  }

  void _startAnimationSequence() async {
    
    _mainController.forward();

    
    await Future.delayed(const Duration(milliseconds: 1000));

    _floatingController.repeat(reverse: true);
    _particleController.repeat();
    _breathingController.repeat(reverse: true);

    setState(() => _isInitialAnimationComplete = true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    _particleController.dispose();
    _breathingController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      
      HapticFeedback.lightImpact();

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      context.read<AuthCubit>().login(email, password);
    } else {
      
      HapticFeedback.selectionClick();
    }
  }

  void _showPremiumSnackbar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: PremiumSnackbarContent(
          message: message,
          isSuccess: isSuccess,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        duration: const Duration(milliseconds: 3000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is AuthSuccess) {
          HapticFeedback.heavyImpact();
          _showPremiumSnackbar('Welcome back! Login successful',
              isSuccess: true);

          
          Future.delayed(const Duration(milliseconds: 1500), () {
            context.pushReplacement('/');
          });
        }

        if (state is AuthFailure) {
          HapticFeedback.selectionClick();
          _showPremiumSnackbar(state.message, isSuccess: false);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            
            const PremiumBackground(),

            
            SafeArea(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _mainController,
                  _floatingController,
                  _breathingController,
                ]),
                builder: (context, child) {
                  return Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Transform.scale(
                              scale: _breathingAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 60.r,
                                      offset: Offset(0, 20.h),
                                      spreadRadius: -10.r,
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFF3B82F6)
                                          .withOpacity(0.1),
                                      blurRadius: 40.r,
                                      offset: Offset(0, 10.h),
                                      spreadRadius: -5.r,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(32.r),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 20, sigmaY: 20),
                                    child: Container(
                                      padding: EdgeInsets.all(32.w),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withOpacity(0.9),
                                            Colors.white.withOpacity(0.7),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(32.r),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          PremiumLoginHeader(
                                            floatingAnimation:
                                                _floatingAnimation,
                                            rotationAnimation:
                                                _rotationAnimation,
                                          ),
                                          SizedBox(height: 48.h),
                                          PremiumLoginForm(
                                            formKey: _formKey,
                                            emailController: _emailController,
                                            passwordController:
                                                _passwordController,
                                            isPasswordVisible:
                                                _isPasswordVisible,
                                            isLoading: _isLoading,
                                            onPasswordVisibilityToggle: () {
                                              HapticFeedback.selectionClick();
                                              setState(() =>
                                                  _isPasswordVisible =
                                                      !_isPasswordVisible);
                                            },
                                            onLoginPressed: _handleLogin,
                                            breathingAnimation:
                                                _breathingAnimation,
                                          ),
                                          SizedBox(height: 32.h),
                                          PremiumLoginFooter(
                                            floatingAnimation:
                                                _floatingAnimation,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
