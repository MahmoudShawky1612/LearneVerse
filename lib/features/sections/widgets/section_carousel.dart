import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> sections;
  final int? selectedSectionIdx;
  final ValueChanged<int> onSectionTap;

  const SectionCarousel({
    super.key,
    required this.sections,
    required this.selectedSectionIdx,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 140.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: sections.length,
        separatorBuilder: (_, __) => SizedBox(width: 16.w),
        itemBuilder: (context, idx) {
          final section = sections[idx];
          final isSelected = selectedSectionIdx == idx;
          final image = section['image'] ?? 'assets/images/post.jpg';
          final progress = _calcProgress(section);
          return GestureDetector(
            onTap: () => onSectionTap(idx),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 180.w,
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : colorScheme.surface,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                ],
                border: Border.all(
                  color: isSelected ? colorScheme.primary : colorScheme.outline.withOpacity(0.08),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
                    child: Image.asset(
                      image,
                      width: 180.w,
                      height: 70.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    child: Text(
                      section['name'],
                      style: textTheme.bodyLarge?.copyWith(
                        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6.h,
                      backgroundColor: colorScheme.surfaceVariant,
                      color: isSelected ? colorScheme.secondary : colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  double _calcProgress(Map<String, dynamic> section) {
    final lessons = section['lessons'] as List;
    if (lessons.isEmpty) return 0.0;
    final done = lessons.where((l) => l['done'] == true).length;
    return done / lessons.length;
  }
} 