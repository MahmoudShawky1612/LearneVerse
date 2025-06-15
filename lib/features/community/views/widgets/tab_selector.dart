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
      'Quizzes',
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

  Widget _buildTabItem(BuildContext context, String label, int index) {
    final isSelected = currentIndex == index;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
