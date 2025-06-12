import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/community/data/models/community_members_model.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../utils/url_helper.dart';
import '../../../community/models/owner_model.dart';
import '../../../home/models/author_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../profile/presentation/views/profile_screen.dart';

class UserItem extends StatelessWidget {
  final CommunityMember user;

  const UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String role = user.role;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = theme.extension<AppThemeExtension>();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600.w),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.06),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {},
            child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        UrlHelper.transformUrl(user.profilePictureURL!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              UrlHelper.transformUrl(user.profilePictureURL ?? ''),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 24.r,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.fullname,
                            style: textTheme.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "@${user.username}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: colorScheme.onSurface.withOpacity(
                                        0.7),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  user.role,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: role == "MEMBER"
                                        ? Colors.blue
                                        : role == "MODERATOR"
                                            ? Colors.orange
                                            : role == "OWNER"
                                                ? Colors.red
                                                : colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Container(
                      constraints: BoxConstraints(maxWidth: 100.w),
                      decoration: BoxDecoration(
                        gradient: themeExtension?.buttonGradient,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: InkWell(
                        onTap: () {
                          context.push('/profile', extra: user.id);
                        },                        borderRadius: BorderRadius.circular(10.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          child: Text(
                            "Profile",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}
