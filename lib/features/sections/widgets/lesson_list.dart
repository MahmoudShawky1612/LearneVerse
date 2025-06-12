import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonList extends StatelessWidget {
  final List<Map<String, dynamic>> lessons;
  final int? selectedLessonIdx;
  final Set<String> doneLessons;
  final int sectionIdx;
  final ValueChanged<int> onLessonTap;

  const LessonList({
    super.key,
    required this.lessons,
    required this.selectedLessonIdx,
    required this.doneLessons,
    required this.sectionIdx,
    required this.onLessonTap,
  });

  String _lessonKey(int sectionIdx, int lessonIdx) => '$sectionIdx-$lessonIdx';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, lessonIdx) {
        final lesson = lessons[lessonIdx];
        final isSelected = selectedLessonIdx == lessonIdx;
        final isDone = doneLessons.contains(_lessonKey(sectionIdx, lessonIdx));
        return Card(
          elevation: isSelected ? 5 : 1,
          color: isSelected ? colorScheme.secondary.withOpacity(0.10) : colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: isSelected
                ? BorderSide(color: colorScheme.secondary, width: 2)
                : BorderSide(color: colorScheme.outline.withOpacity(0.1)),
          ),
          margin: EdgeInsets.symmetric(vertical: 7.h, horizontal: 8.w),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            title: Text(
              lesson['name'],
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                decoration: isDone ? TextDecoration.lineThrough : null,
                color: isDone ? colorScheme.secondary : (isSelected ? colorScheme.secondary : colorScheme.onSurface),
              ),
            ),
            trailing: isDone
                ? Icon(Icons.check_circle, color: colorScheme.secondary)
                : null,
            selected: isSelected,
            onTap: () => onLessonTap(lessonIdx),
          ),
        );
      },
    );
  }
} 