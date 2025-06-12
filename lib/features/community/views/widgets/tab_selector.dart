import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';

class TabSelector extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final bool showJoinRequestsTab;

  const TabSelector({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.showJoinRequestsTab = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = [
      'Info',
      'Classroom',
      'Forum',
      'Leaderboard',
      'Members',
    ];
    if (showJoinRequestsTab) {
      tabs.add('Join Requests');
    }

    return SizedBox(
      height: 50.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          return _buildTabItem(context, tabs[index], index);
        },
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String title, int index) {
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Container(
        margin: EdgeInsets.only(right: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        decoration: BoxDecoration(
          gradient: isSelected ? themeExtension?.buttonGradient : null,
          color: isSelected ? null : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
