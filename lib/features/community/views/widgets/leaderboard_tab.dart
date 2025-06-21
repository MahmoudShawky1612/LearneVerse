import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/community/service/forum_service.dart';
import 'package:flutterwidgets/features/profile/views/widgets/no_profile_widget.dart';
import 'package:flutterwidgets/utils/error_state.dart';
import 'package:flutterwidgets/utils/loading_state.dart';

import 'podium_item.dart';
import 'top_member_item.dart';

class LeaderboardTab extends StatelessWidget {
  final int communityId;

  const LeaderboardTab({super.key, required this.communityId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = theme.extension<AppThemeExtension>();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ForumApiService().fetchLeaderboardQuizScores(communityId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingState();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorStateWidget(
              onRetry: () {
                context
                    .read<ForumApiService>()
                    .fetchLeaderboardQuizScores(communityId);
              },
              message: snapshot.error.toString(),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: NoDataWidget(message: 'Keep it up, no one has scored yet!'),
          );
        }

        final data = snapshot.data!;
        final podium = data.take(3).toList();
        final rest = data.length > 3 ? data.sublist(3) : [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 24.h),
            Text(
              'Top Members',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (podium.length > 1)
                  PodiumItem(
                    user: _LeaderboardUser(
                      id: podium[1]['userId'] ?? 0,
                      name: podium[1]['fullname'] ?? '',
                      points: podium[1]['totalScore'] ?? 0,
                      avatar: podium[1]['profilePictureURL'] ?? '',
                    ),
                    rank: 2,
                    height: 130.h,
                    theme: theme,
                    colorScheme: colorScheme,
                    themeExtension: themeExtension,
                    isFirst: false,
                  ),
                if (podium.isNotEmpty)
                  PodiumItem(
                    user: _LeaderboardUser(
                      id: podium[0]['userId'] ?? 0,
                      name: podium[0]['fullname'] ?? '',
                      points: podium[0]['totalScore'] ?? 0,
                      avatar: podium[0]['profilePictureURL'] ?? '',
                    ),
                    rank: 1,
                    height: 170.h,
                    theme: theme,
                    colorScheme: colorScheme,
                    themeExtension: themeExtension,
                    isFirst: true,
                  ),
                if (podium.length > 2)
                  PodiumItem(
                    user: _LeaderboardUser(
                      id: podium[2]['userId'] ?? 0,
                      name: podium[2]['fullname'] ?? '',
                      points: podium[2]['totalScore'] ?? 0,
                      avatar: podium[2]['profilePictureURL'] ?? '',
                    ),
                    rank: 3,
                    height: 100.h,
                    theme: theme,
                    colorScheme: colorScheme,
                    themeExtension: themeExtension,
                    isFirst: false,
                  ),
              ],
            ),
            SizedBox(height: 32.h),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: <Widget>[
                        const Text(
                          'Rank',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 24.w),
                        const Expanded(
                          child: Text(
                            'User',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Text(
                          'Points',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1.h),
                  ...List.generate(rest.length, (index) {
                    final user = rest[index];
                    return TopMemberItem(
                      id: user['userId'] ?? 0,
                      rank: index + 4,
                      name: user['fullname'] ?? '',
                      username: user['username'] ?? '',
                      avatarUrl: user['profilePictureURL'] ?? '',
                      points: user['totalScore'] ?? 0,
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LeaderboardUser {
  final int id;
  final String name;
  final int points;
  final String avatar;

  _LeaderboardUser({
    required this.id,
    required this.name,
    required this.points,
    required this.avatar,
  });
}
