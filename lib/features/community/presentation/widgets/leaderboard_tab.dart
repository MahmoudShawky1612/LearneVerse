import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/profile/presentation/widgets/no_profile_widget.dart';
import 'package:flutterwidgets/utils/error_state.dart';
import 'podium_item.dart';
import 'top_member_item.dart';
import 'package:flutterwidgets/features/community/services/forum_service.dart';
import 'package:flutterwidgets/utils/loading_state.dart';

class LeaderboardTab extends StatelessWidget {
  final int communityId;
  const LeaderboardTab({super.key, required this.communityId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ForumApiService().fetchLeaderboardQuizScores(communityId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingState();
        } else if (snapshot.hasError) {
          return Center(child: ErrorStateWidget(onRetry: (){}, message: snapshot.error.toString(),));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return   Center(child: Column(
            children: [
              const NoDataWidget(message: 'Keep it up, no one has scored yet!'),
              SizedBox(height: 30.h),
            ],
          ));
        }
        final data = snapshot.data!;
        // Top 3 for podium
        final podium = data.take(3).toList();
        // Rest for list
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
              children: List.generate(podium.length, (i) {
                final user = podium[i]['User'];
                return PodiumItem(
                  user: _LeaderboardUser(
                    id: user['id'] ?? 0,
                    name: user['fullname'] ?? '',
                    points: podium[i]['score'] ?? 0,
                    avatar: user['UserProfile']?['profilePictureURL'] ?? '',
                  ),
                  rank: i + 1,
                  height: [170.h, 130.h, 100.h][i],
                  theme: theme,
                  colorScheme: colorScheme,
                  themeExtension: themeExtension,
                  isFirst: i == 1,
                );
              }),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 24.w),
                        const Expanded(
                          child: Text(
                            'User',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Text(
                          'Points',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1.h),
                  ...List.generate(rest.length, (index) {
                    final user = rest[index]['User'];
                    return TopMemberItem(
                      id: user['id'] ?? 0,
                      rank: index + 4,
                      name: user['fullname'] ?? '',
                      username: '${user['username']}' ?? '',
                      avatarUrl: user['UserProfile']?['profilePictureURL'] ?? '',
                      points: rest[index]['score'] ?? 0,
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
  _LeaderboardUser( {required this.id, required this.name, required this.points, required this.avatar});
}