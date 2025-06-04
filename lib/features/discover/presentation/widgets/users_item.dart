import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../community/models/owner_model.dart';
import '../../../home/models/author_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../profile/presentation/views/profile_screen.dart';

class UserItem extends StatelessWidget {
  final user;

  const UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String role = user.role;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = theme.extension<AppThemeExtension>();
    final screenWidth = MediaQuery.of(context).size.width;

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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: Image.asset(
                      user.avatar,
                      width: 30.w,
                      height: 30.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.name,
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
                                "@${user.userName}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: colorScheme.onSurface.withOpacity(0.7),
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
                                role,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: role == "Member"
                                      ? colorScheme.onSurface
                                      : colorScheme.tertiary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Flexible(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 100.w),
                        decoration: BoxDecoration(
                          gradient: themeExtension?.buttonGradient,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: InkWell(
                          onTap: () => navigateToProfile(context),
                          borderRadius: BorderRadius.circular(10.r),
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
                    ),
                  ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigateToProfile(BuildContext context) {
    if (user is Owner) {
      final ownerUser = user as Owner;
      final authorFromOwner = Author(
        id: ownerUser.id,
        name: ownerUser.name,
        avatar: ownerUser.avatar,
        userName: ownerUser.userName,
        role: ownerUser.role,
        points: 0,
        joinedCommunities: [],
        quote: "Owner of communities",
        totalJoinedCommunities: 0,
        totalPostUpvotes: 0,
        totalCommentUpvotes: 0,
        interests: [],
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userInfo: authorFromOwner),
        ),
      );
    } else {
      try {
        List<Author> users = Author.users;
        final selectedUser =
            users.firstWhere((u) => u.userName == user.userName);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(userInfo: selectedUser),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile not available')),
        );
      }
    }
  }
}
