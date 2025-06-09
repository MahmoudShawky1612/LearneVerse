import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/profile/data/models/user_profile_model.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../login/presentation/widgets/snackbar.dart';
import 'profile_avatar_and_name.dart';
import 'profile_bio_quote.dart';
import 'profile_social_links_row.dart';
import 'profile_user_stats_row.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile userInfo;

  const ProfileHeader({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    final size = MediaQuery.of(context).size;

    final expandedHeight = (size.height * 0.35).h;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.logout, color: colorScheme.onPrimary),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor:
                          const Color(0xFF1E1E1E), 
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: const Text(
                        'Confirm Logout',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        'Are you sure you want to log out?',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context), 
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.grey[400])),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context); 
                            TokenStorage.deleteToken();
                            context.go('/login');
                            showPremiumSnackbar(
                              context,
                              message: "Logged out successfully",
                              isSuccess: true,
                            );
                          },
                          child: const Text('Logout',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: themeExtension?.backgroundGradient ??
                        LinearGradient(
                          colors: [
                            colorScheme.primary.withOpacity(0.9),
                            colorScheme.primary,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 16.h,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),
                            ProfileAvatarAndName(userInfo: userInfo),
                            SizedBox(height: 12.h),
                            ProfileBioQuote(userInfo: userInfo),
                            SizedBox(height: 14.h),
                            if (userInfo.tags.isNotEmpty)
                              _buildInterestTags(colorScheme, userInfo),
                            SizedBox(height: 12.h),
                             Center(child: ProfileSocialLinksRow(userInfo: userInfo)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInterestTags(ColorScheme colorScheme, UserProfile userInfo) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8.w,
        runSpacing: 8.h,
        children: userInfo.tags.map<Widget>((tag) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.5),
                width: 1.w,
              ),
            ),
            child: Text(
              tag.name,
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
