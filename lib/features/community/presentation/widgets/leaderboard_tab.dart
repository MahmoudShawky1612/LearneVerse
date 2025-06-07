import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'podium_item.dart';
import 'top_member_item.dart';

class LeaderboardTab extends StatelessWidget {
  final List<dynamic> members;

  const LeaderboardTab({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Text(
          'Top Contributors',
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
            PodiumItem(
              user: members[1],
              rank: 2,
              height: 120.h,
              theme: theme,
              colorScheme: colorScheme,
              themeExtension: themeExtension,
            ),
            SizedBox(width: 12.w),
            PodiumItem(
              user: members[0],
              rank: 1,
              height: 150.h,
              theme: theme,
              colorScheme: colorScheme,
              themeExtension: themeExtension,
              isFirst: true,
            ),
            SizedBox(width: 12.w),
            PodiumItem(
              user: members[2],
              rank: 3,
              height: 100.h,
              theme: theme,
              colorScheme: colorScheme,
              themeExtension: themeExtension,
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
              ...List.generate(
                7,
                    (index) => TopMemberItem(
                  rank: index + 4,
                  name: members[index + 3].name,
                  username: members[index + 3].userName,
                  avatarUrl: members[index + 3].avatar,
                  points: members[index + 3].points,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}