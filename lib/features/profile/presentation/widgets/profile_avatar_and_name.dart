import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';

class ProfileAvatarAndName extends StatelessWidget {
  final userInfo;
  const ProfileAvatarAndName({super.key, this.userInfo});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.onPrimary, width: 3.w),
                borderRadius: BorderRadius.circular(40.r),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage:
                    AssetImage(userInfo?.avatar ?? 'assets/images/avatar.jpg'),
                radius: 36,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 18.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: themeExtension?.upVote ?? colorScheme.primary,
                  border: Border.all(color: colorScheme.onPrimary, width: 2.w),
                  borderRadius: BorderRadius.circular(9.r),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userInfo.name ?? 'unknown',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onPrimary,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ],
    );
  }
}
