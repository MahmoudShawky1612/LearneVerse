import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class TopMemberItem extends StatelessWidget {
  final int id;
  final int rank;
  final String name;
  final String username;
  final String avatarUrl;
  final int points;

  const TopMemberItem({
    super.key,
    required this.rank,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.points,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5.w,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(
            '$rank',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: rank <= 3 ? colorScheme.primary : null,
            ),
          ),
          SizedBox(width: 24.w),
          InkWell(
            onTap: () {
              context.push('/profile', extra: id);
            },
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: themeExtension?.circleGradient,
              ),
              child: ClipOval(
                child: (avatarUrl.isEmpty)
                    ? const Icon(Icons.person, color: Colors.blue, size: 20)
                    : CachedNetworkImage(
                  imageUrl: avatarUrl,
                  width: 36.w,
                  height: 36.h,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) => const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 20),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1, // Restrict to one line
                  overflow: TextOverflow.ellipsis, // Show ellipsis for overflow
                ),
                Text(
                  '@$username',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                  maxLines: 1, // Restrict to one line
                  overflow: TextOverflow.ellipsis, // Show ellipsis for overflow
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$points pts',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}