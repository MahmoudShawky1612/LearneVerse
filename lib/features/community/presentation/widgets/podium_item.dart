import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';

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
    // Premium, sophisticated colors for each rank
    Color primaryColor;
    Color accentColor;
    Color shadowColor;

    switch (rank) {
      case 1:
        primaryColor = const Color(0xFFF0C164); // Brighter, more vibrant gold
        accentColor = const Color(0xFFCFA108);  // Richer gold accent
        shadowColor = const Color(0xFFDEB03A); // Slightly lighter gold shadow
        break;
      case 2:
        primaryColor = const Color(0xFF85A8C2); // Livelier blue-gray
        accentColor = const Color(0xFF557A8A);  // More vibrant deep blue-gray
        shadowColor = const Color(0xFF668A9A); // Brighter blue-gray shadow
        break;
      case 3:
        primaryColor = const Color(0xFF95A88A); // More vibrant sage green
        accentColor = const Color(0xFF677B5A);  // Richer deep sage
        shadowColor = const Color(0xFF758B6A); // Lighter sage shadow
        break;
      default:
        primaryColor = colorScheme.primary;
        accentColor = colorScheme.secondary;
        shadowColor = colorScheme.primary;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Premium avatar with refined styling
        GestureDetector(
          onTap: () {
             context.push('/profile', extra: user.id);
          },
          child: Container(
            width: isFirst ? 75.w : 65.w,
            height: isFirst ? 75.h : 65.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.3),
                  blurRadius: 12.r,
                  offset: Offset(0, 6.h),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 6.r,
                  offset: Offset(0, -2.h),
                ),
              ],
            ),
            padding: EdgeInsets.all(3.w),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: ClipOval(
                child: (user.avatar == null || user.avatar.isEmpty)
                    ? Icon(
                  Icons.person,
                  color: accentColor,
                  size: isFirst ? 36.sp : 30.sp,
                )
                    : Image.network(
                  user.avatar,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        color: accentColor,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    color: accentColor,
                    size: isFirst ? 36.sp : 30.sp,
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // Refined name text
        Text(
          user.name,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isFirst ? 16.sp : 14.sp,
            color: colorScheme.onSurface,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: 8.h),

        // Premium points display
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor.withOpacity(0.08),
                primaryColor.withOpacity(0.12),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: primaryColor.withOpacity(0.25),
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 4.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Text(
            '${user.points} pts',
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.w600,
              fontSize: isFirst ? 13.sp : 12.sp,
              letterSpacing: 0.2,
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // Premium podium with refined styling
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: isFirst ? 90.w : 80.w,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryColor,
                    primaryColor.withOpacity(0.85),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withOpacity(0.25),
                    blurRadius: 12.r,
                    offset: Offset(0, 6.h),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 4.r,
                    offset: Offset(0, -2.h),
                  ),
                ],
              ),
            ),

            // Premium rank number
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8.r,
                    offset: Offset(0, 3.h),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 2.r,
                    offset: Offset(0, -1.h),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 18.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}