import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';

class BuildFilterChip extends StatelessWidget {
  final int index;
  final List<String> filters;
  final bool isSelected;
  final Function(String) onToggle;

  const BuildFilterChip({
    super.key,
    required this.index,
    required this.filters,
    this.isSelected = false,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    return Container(
      margin: EdgeInsets.only(right: 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onToggle(filters[index]),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 70.w,
            padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 10.h),
            decoration: BoxDecoration(
              gradient: isSelected ? null : themeExtension?.buttonGradient,
              color: isSelected ? theme.cardColor : null,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 1.5.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? theme.shadowColor.withOpacity(0.08)
                      : colorScheme.primary.withOpacity(0.25),
                  blurRadius: 6.r, 
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                filters[index],
                style: TextStyle(
                  color:
                      isSelected ? colorScheme.primary : colorScheme.onPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 12.sp, 
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
