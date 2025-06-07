import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';

class JoinButton extends StatelessWidget {
  final bool userHasJoined;
  final VoidCallback onJoinToggle;

  const JoinButton({
    super.key,
    required this.userHasJoined,
    required this.onJoinToggle,
  });

  @override
  Widget build(BuildContext context) {
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onJoinToggle,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.w),
        decoration: BoxDecoration(
          gradient: themeExtension?.buttonGradient,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            userHasJoined ? 'Leave Community' : 'Join Community',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}