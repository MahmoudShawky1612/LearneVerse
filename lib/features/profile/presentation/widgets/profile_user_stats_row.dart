import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'profile_user_stat.dart';

class ProfileUserStatsRow extends StatelessWidget {
  final userInfo;

  const ProfileUserStatsRow({super.key, this.userInfo});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 8.w),
          const ProfileUserStat(
              value: "Mar 31, 2025",
              icon: Icons.calendar_today,
              label: "Joined"),
          SizedBox(width: 8.w),
          ProfileUserStat(
              value: userInfo?.totalJoinedCommunities?.toString() ?? "42",
              icon: Icons.people,
              label: "Communities"),
          SizedBox(width: 8.w),
          ProfileUserStat(
              value: userInfo?.totalPostUpvotes?.toString() ?? "156",
              icon: Icons.arrow_upward_outlined,
              label: "Total Post Upvotes"),
          SizedBox(width: 8.w),
          ProfileUserStat(
              value: userInfo?.totalCommentUpvotes?.toString() ?? "532",
              icon: Icons.arrow_upward_outlined,
              label: "Total Comment Upvotes"),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }
}
