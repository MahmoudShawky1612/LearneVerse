import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileSocialButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onPressed;

  const ProfileSocialButton({
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
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.onPrimary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24),
        ),
        child: FaIcon(
          icon,
          color: buttonColor,
          size: 18,
        ),
      ),
    );
  }
}
