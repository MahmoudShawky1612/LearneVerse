import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileSocialButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onPressed;

  const ProfileSocialButton({super.key, 
    required this.icon,
    this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final buttonColor = color ?? colorScheme.onPrimary;
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        padding:   EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: colorScheme.onPrimary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: FaIcon(
          icon,
          color: buttonColor,
          size: 18.r,
        ),
      ),
    );
  }
}
