import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonDetail extends StatelessWidget {
  final Map<String, dynamic> lesson;
  final bool isDone;
  final VoidCallback onMarkDone;

  const LessonDetail({
    super.key,
    required this.lesson,
    required this.isDone,
    required this.onMarkDone,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final material = lesson['material'] as Map<String, dynamic>;
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lesson['name'],
                style: textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 12.h),
            Text(lesson['notes'], style: textTheme.bodyLarge),
            SizedBox(height: 24.h),
            _buildMaterialPreview(material, colorScheme),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                icon: Icon(isDone ? Icons.check : Icons.done),
                label: Text(isDone ? 'Done' : 'Mark as Done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDone ? colorScheme.secondary : colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  elevation: isDone ? 0 : 4,
                ),
                onPressed: isDone ? null : onMarkDone,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialPreview(
      Map<String, dynamic> material, ColorScheme colorScheme) {
    switch (material['type']) {
      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.network(
            material['path'],
            width: 320.w,
            height: 180.h,
            fit: BoxFit.cover,
          ),
        );
      case 'video':
        return Container(
          width: 320.w,
          height: 180.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: Icon(Icons.play_circle_fill,
                size: 64.r, color: colorScheme.primary),
          ),
        );
      case 'doc':
        return Container(
          width: 320.w,
          height: 120.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description, size: 48.r, color: colorScheme.primary),
              SizedBox(width: 16.w),
              Text('View Document',
                  style:
                      TextStyle(fontSize: 18.sp, color: colorScheme.primary)),
            ],
          ),
        );
      case 'recording':
        return Container(
          width: 320.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.audiotrack, size: 40.r, color: colorScheme.primary),
              SizedBox(width: 16.w),
              Text('Play Recording',
                  style:
                      TextStyle(fontSize: 18.sp, color: colorScheme.primary)),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
