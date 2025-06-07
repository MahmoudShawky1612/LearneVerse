import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';

class PodiumItem extends StatelessWidget {
  final dynamic user;
  final int rank;
  final double height;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final AppThemeExtension? themeExtension;
  final bool isFirst;

  const PodiumItem({
    super.key,
    required this.user,
    required this.rank,
    required this.height,
    required this.theme,
    required this.colorScheme,
    required this.themeExtension,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    Color medalColor;
    switch (rank) {
      case 1:
        medalColor = const Color(0xFFFFD700);
        break;
      case 2:
        medalColor = const Color(0xFFC0C0C0);
        break;
      case 3:
        medalColor = const Color(0xFFCD7F32);
        break;
      default:
        medalColor = colorScheme.primary;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: medalColor, width: 3.w),
            boxShadow: [
              BoxShadow(
                color: medalColor.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              user.avatar,
              width: 60.w,
              height: 60.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          user.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isFirst ? 16.sp : 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
          decoration: BoxDecoration(
            color: medalColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: medalColor.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${user.points} pts',
            style: TextStyle(
              color: medalColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    medalColor.withOpacity(0.7),
                    medalColor.withOpacity(0.4),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: medalColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: medalColor.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: medalColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}