import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'rating_stars.dart';

class CommunityHeader extends StatelessWidget {
  final Community community;

  const CommunityHeader({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    final theme = Theme.of(context);

    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 40.r,
          backgroundImage: NetworkImage(community.logoImgURL),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                community.name,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.people,
                    size: 16.w,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${community.memberCount} members',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.circle_rounded,
                    size: 9.w,
                    color:Colors.green,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${community.onlineMembers} Online',
                    style: const TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    community.isPublic
                        ? Icons.lock_open
                        : Icons.lock,
                    size: 16,
                    color: community.isPublic
                        ? themeExtension?.upVote
                        : themeExtension?.downVote,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    community.isPublic ? 'Public' : 'Private',
                    style: TextStyle(
                      color: community.isPublic
                          ? themeExtension?.upVote
                          : themeExtension?.downVote,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}