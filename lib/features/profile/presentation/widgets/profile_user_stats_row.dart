import 'package:flutter/material.dart';

import 'profile_user_stat.dart';

class ProfileUserStatsRow extends StatelessWidget {
  final userInfo;

  ProfileUserStatsRow({super.key, this.userInfo});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 8),
          const ProfileUserStat(
              value: "Mar 31, 2025",
              icon: Icons.calendar_today,
              label: "Joined"),
          const SizedBox(width: 8),
          ProfileUserStat(
              value: userInfo?.totalJoinedCommunities?.toString() ?? "42",
              icon: Icons.people,
              label: "Communities"),
          const SizedBox(width: 8),
          ProfileUserStat(
              value: userInfo?.totalPostUpvotes?.toString() ?? "156",
              icon: Icons.arrow_upward_outlined,
              label: "Total Post Upvotes"),
          const SizedBox(width: 8),
          ProfileUserStat(
              value: userInfo?.totalCommentUpvotes?.toString() ?? "532",
              icon: Icons.arrow_upward_outlined,
              label: "Total Comment Upvotes"),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
