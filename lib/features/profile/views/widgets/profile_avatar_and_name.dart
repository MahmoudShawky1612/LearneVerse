 import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/profile/data/models/user_profile_model.dart';
import 'package:flutterwidgets/utils/url_helper.dart';
import 'package:path/path.dart';

class ProfileAvatarAndName extends StatelessWidget {
  final UserProfile userInfo;
  const ProfileAvatarAndName({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                radius: 36.r,
                backgroundColor: Colors.grey[200],
                child: userInfo.profilePictureURL.isEmpty
                    ? Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 40.sp,
                )
                    : ClipOval(
                    child: CachedNetworkImage(
                    imageUrl: UrlHelper.transformUrl(userInfo.profilePictureURL),
                    width: 72.r, // 2 * radius
                    height: 72.r,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 40.sp,
                    ),
                  ),
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
                userInfo.user.fullname,
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
              Text(
                '@${userInfo.user.username}',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: colorScheme.onPrimary,
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}