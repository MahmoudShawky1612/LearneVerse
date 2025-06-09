import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/utils/url_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../home/data/models/community_model.dart';

class UserCommunityItem extends StatelessWidget {
  final Community community;
  final VoidCallback? onTap;
  final VoidCallback? onJoinLeave;

  const UserCommunityItem({
    super.key,
    required this.community,
    this.onTap,
    this.onJoinLeave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: _buildShadowDecoration(theme),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                _buildCommunityImage(theme),
                SizedBox(width: 10.w),
                _buildCommunityDetails(context),
                SizedBox(width: 10.w),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildShadowDecoration(ThemeData theme) => BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      );

  Widget _buildCommunityImage(ThemeData theme) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14.r),
      boxShadow: [
        BoxShadow(
          color: theme.shadowColor.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: Image.network(
        UrlHelper.transformUrl(community.logoImgURL),
        width: 40.w,
        height: 40.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 40.w,
            height: 40.h,
            color: theme.colorScheme.surfaceVariant, // fallback background
            child: Icon(
              Icons.broken_image,
              size: 24.r,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          );
        },
      ),
    ),
  );

  Widget _buildCommunityDetails(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            community.name,
            style: textTheme.titleMedium?.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5.h),
         ],
      ),
    );
  }



  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: themeExtension?.buttonGradient,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: InkWell(
            onTap: ()
              =>
                context.push('/community', extra: community),


            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.arrow_forward,
                      size: 14.w, color: colorScheme.onPrimary),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
