import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnackBarUtils {
  static void showSuccessSnackBar(
      BuildContext context, {
        required String message,
        String? actionLabel,
        VoidCallback? onActionPressed,
        Duration duration = const Duration(seconds: 3),
      }) {
    _showCustomSnackBar(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: Colors.green.shade600,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  static void showErrorSnackBar(
      BuildContext context, {
        required String message,
        String? actionLabel,
        VoidCallback? onActionPressed,
        Duration duration = const Duration(seconds: 4),
      }) {
    _showCustomSnackBar(
      context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: Colors.red.shade600,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  static void showInfoSnackBar(
      BuildContext context, {
        required String message,
        String? actionLabel,
        VoidCallback? onActionPressed,
        Duration duration = const Duration(seconds: 3),
      }) {
    _showCustomSnackBar(
      context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: Colors.blue.shade600,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  static void showWarningSnackBar(
      BuildContext context, {
        required String message,
        String? actionLabel,
        VoidCallback? onActionPressed,
        Duration duration = const Duration(seconds: 3),
      }) {
    _showCustomSnackBar(
      context,
      message: message,
      icon: Icons.warning_amber_outlined,
      backgroundColor: Colors.orange.shade600,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  static void _showCustomSnackBar(
      BuildContext context, {
        required String message,
        required IconData icon,
        required Color backgroundColor,
        String? actionLabel,
        VoidCallback? onActionPressed,
        required Duration duration,
      }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.all(16.w),
      duration: duration,
      action: actionLabel != null
          ? SnackBarAction(
        label: actionLabel,
        textColor: Colors.white,
        onPressed: onActionPressed ?? () {},
      )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}