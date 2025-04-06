import 'package:flutter/material.dart';
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
      margin: const EdgeInsets.only(right: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onToggle(filters[index]),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              gradient: isSelected ? null : themeExtension?.buttonGradient,
              color: isSelected ? theme.cardColor : null,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? theme.shadowColor.withOpacity(0.08)
                      : colorScheme.primary.withOpacity(0.25),
                  blurRadius: 6, // Reduced from 8
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
                  fontSize: 12, // Reduced from 14
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
