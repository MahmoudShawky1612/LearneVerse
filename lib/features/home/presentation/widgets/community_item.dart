import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CommunityItem extends StatelessWidget {
  final dynamic community;

  const CommunityItem({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    // Responsive width based on screen size
    final itemWidth =  140.0.w;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: itemWidth,
      margin:   EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.08),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top content section
          Padding(
            padding:   EdgeInsets.only(top: 12.w, bottom: 6.w),
            child: _buildCommunityIcon(colorScheme),
          ),

          // Community name
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            child: Text(
              community.name,
              style: textTheme.titleMedium?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                height: 1.2.h,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Member count
          _buildMemberCount(colorScheme, textTheme),

            SizedBox(height: 8.w),

          // View button
          _buildViewButton(context, colorScheme, themeExtension),
        ],
      ),
    );
  }

  Widget _buildCommunityIcon(ColorScheme colorScheme) {
    return Container(
      padding:   EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.05),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Image(
        image: AssetImage(community.image),
        width: 40.h,
        height: 40.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildMemberCount(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding:   EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.userFriends,
            size: 9,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
           SizedBox(width: 4.w),
          Text(
            '${community.memberCount}',
            style: textTheme.bodySmall?.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewButton(
      BuildContext context,
      ColorScheme colorScheme,
      AppThemeExtension? themeExtension
      ) {
    return Container(
      width: double.infinity,
      height: 32.h,
      margin:   EdgeInsets.fromLTRB(6.w, 0, 6.w, 6.w),
      decoration: BoxDecoration(
        gradient: themeExtension?.buttonGradient,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/community', extra: community),
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                  SizedBox(width: 2.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: colorScheme.onPrimary,
                  size: 12.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}