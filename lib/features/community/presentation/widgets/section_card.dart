import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'info_chip.dart';

class SectionCard extends StatelessWidget {
  final Map<String, dynamic> section;

  const SectionCard({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    section['image'] as String,
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        section['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: <Widget>[
                          InfoChip(
                            icon: Icons.book,
                            label: '${section['lessons']} lessons',
                          ),
                          SizedBox(width: 8.w),
                          InfoChip(
                            icon: Icons.access_time,
                            label: section['duration'] as String,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      LinearProgressIndicator(
                        value: (section['completed'] as int) /
                            (section['lessons'] as int),
                        backgroundColor:
                        theme.colorScheme.surfaceContainerHighest,
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${section['completed']}/${section['lessons']} completed',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}