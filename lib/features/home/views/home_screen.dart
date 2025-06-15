import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/widgets/theme_toggle_button.dart';
import 'package:flutterwidgets/features/home/views/widgets/home_header.dart';
import 'package:flutterwidgets/features/home/views/widgets/main_content.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/token_storage.dart';
import '../../login/views/widgets/snackbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildMobileLayout(),
            _buildTopRightButtons(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRightButtons(ThemeData theme, ColorScheme colorScheme) {
    return Positioned(
      right: 16.w,
      top: 16.h,
      child: FadeTransition(
        opacity: _fadeController,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeToggleButton(theme),
            SizedBox(width: 10.w),
            _buildLogoutButton(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggleButton(ThemeData theme) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface.withOpacity(0.9),
            theme.colorScheme.surface.withOpacity(0.7),
          ],
        ),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: theme.colorScheme.surface.withOpacity(0.8),
            blurRadius: 8,
            offset: const Offset(0, -2),
           ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            _scaleController.forward().then((_) {
              _scaleController.reverse();
            });
            // Your theme toggle logic here
          },
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 1.0,
              end: 0.95,
            ).animate(CurvedAnimation(
              parent: _scaleController,
              curve: Curves.easeInOut,
            )),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: ThemeToggleButton(
                  isCompact: true,
                  size: 12.w,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(ColorScheme colorScheme) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.withOpacity(0.1),
            Colors.red.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.red.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => _showModernLogoutDialog(context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 18.w,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showModernLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.red.shade400,
                    size: 32.w,
                  ),
                ),
                SizedBox(height: 20.h),

                // Title
                Text(
                  'Confirm Logout',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  'Are you sure you want to log out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 32.h),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildDialogButton(
                        text: 'Cancel',
                        isPrimary: false,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildDialogButton(
                        text: 'Logout',
                        isPrimary: true,
                        onPressed: () {
                          Navigator.pop(context);
                          TokenStorage.deleteToken();
                          context.go('/login');
                          showPremiumSnackbar(
                            context,
                            message: "Logged out successfully",
                            isSuccess: true,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: isPrimary
            ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.shade400,
            Colors.red.shade500,
          ],
        )
            : null,
        color: isPrimary ? null : Theme.of(context).colorScheme.surface,
        border: isPrimary
            ? null
            : Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: isPrimary
            ? [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isPrimary
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        const HomeHeader(),
        Expanded(
          child: Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: const MainContent(),
          ),
        ),
      ],
    );
  }
}