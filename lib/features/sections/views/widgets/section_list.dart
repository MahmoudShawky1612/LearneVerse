import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionList extends StatelessWidget {
  final List<Map<String, dynamic>> sections;
  final int? selectedSectionIdx;
  final ValueChanged<int> onSectionTap;

  const SectionList({
    super.key,
    required this.sections,
    required this.selectedSectionIdx,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, sectionIdx) {
        final section = sections[sectionIdx];
        final isSelected = selectedSectionIdx == sectionIdx;
        return Card(
          elevation: isSelected ? 6 : 1,
          color: isSelected
              ? colorScheme.primary.withOpacity(0.12)
              : colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
            side: isSelected
                ? BorderSide(color: colorScheme.primary, width: 2)
                : BorderSide(color: colorScheme.outline.withOpacity(0.1)),
          ),
          margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
            title: Text(
              section['name'],
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.arrow_right,
                    color: colorScheme.primary, size: 28.r)
                : null,
            selected: isSelected,
            onTap: () => onSectionTap(sectionIdx),
          ),
        );
      },
    );
  }
}
