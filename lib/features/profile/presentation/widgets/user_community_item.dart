import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

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
      margin:   EdgeInsets.only(bottom: 20.h),
      decoration: _buildShadowDecoration(theme),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding:   EdgeInsets.all(16.r),
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
          child: Image.asset(
            community.image,
            width: 40.w,
            height: 40.h,
            fit: BoxFit.cover,
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
          Wrap(
            spacing: 5,
            runSpacing: 2,
            children: [
              _buildMemberCount(context),
              _buildPrivacyBadge(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCount(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _buildBadge(
      context: context,
      color: colorScheme.primary.withOpacity(0.1),
      textColor: colorScheme.primary,
      icon: FontAwesomeIcons.userFriends,
      label: '${community.memberCount}',
    );
  }

  Widget _buildPrivacyBadge(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    return _buildBadge(
      context: context,
      color: colorScheme.surfaceContainerHighest,
      textColor: community.communityPrivacy == "Public"
          ? themeExtension?.upVote ?? colorScheme.primary
          : themeExtension?.downVote ?? colorScheme.error,
      icon: community.communityPrivacy == "Public"
          ? FontAwesomeIcons.lockOpen
          : FontAwesomeIcons.lock,
      label: community.communityPrivacy,
      fontSize: 6.sp,
    );
  }

  Widget _buildBadge({
    required BuildContext context,
    required Color color,
    required Color textColor,
    required IconData icon,
    required String label,
    double fontSize = 9,
  }) =>
      Container(
        padding:   EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: fontSize + 1, color: textColor),
              SizedBox(width: 3.w),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ],
        ),
      );

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
            onTap: () {
              {
                context.push('/community', extra: community);
              }
            },
            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding:   EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
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
                  Icon(Icons.arrow_forward, size: 14.w, color: colorScheme.onPrimary),
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
