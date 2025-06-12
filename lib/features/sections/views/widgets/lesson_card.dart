import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonCard extends StatelessWidget {
  final Map<String, dynamic> lesson;
  final bool isSelected;
  final bool isDone;
  final VoidCallback onTap;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.isSelected,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final icon = _iconForType(lesson['material']['type']);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.secondary.withOpacity(0.12)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSelected
              ? colorScheme.secondary
              : colorScheme.outline.withOpacity(0.08),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: colorScheme.secondary.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon,
            color: isSelected ? colorScheme.secondary : colorScheme.primary,
            size: 32.r),
        title: Text(
          lesson['name'],
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDone ? colorScheme.secondary : colorScheme.onSurface,
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: isDone
            ? Icon(Icons.check_circle, color: colorScheme.secondary)
            : null,
        onTap: onTap,
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'image':
        return Icons.image_rounded;
      case 'video':
        return Icons.play_circle_fill_rounded;
      case 'doc':
        return Icons.description_rounded;
      case 'recording':
        return Icons.audiotrack_rounded;
      default:
        return Icons.book_rounded;
    }
  }
}
