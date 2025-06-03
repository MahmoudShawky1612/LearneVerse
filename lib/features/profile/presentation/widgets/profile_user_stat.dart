import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileUserStat extends StatelessWidget {
  final String value;
  final IconData icon;
  final String label;

  const ProfileUserStat({super.key, 
    required this.value,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding:   EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12.w, color: colorScheme.onPrimary),
                SizedBox(width: 3.w),
              Text(
                value,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
            SizedBox(height: 1.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              color: colorScheme.onPrimary.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
