import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'section_card.dart';

class ClassroomTab extends StatelessWidget {
  final dynamic community;

  const ClassroomTab({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> sections = [
      {
        'title': 'Introduction to the Community',
        'lessons': 3,
        'completed': 2,
        'duration': '45 minutes',
        'image': community.communityBackgroundImage,
      },
      {
        'title': 'Getting Started with Projects',
        'lessons': 5,
        'completed': 0,
        'duration': '1.5 hours',
        'image': community.communityBackgroundImage,
      },
      {
        'title': 'Advanced Techniques',
        'lessons': 8,
        'completed': 0,
        'duration': '3 hours',
        'image': community.communityBackgroundImage,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Learning Sections',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...sections.map((section) => SectionCard(section: section)),
        SizedBox(height: 24.h),
        SizedBox(height: 36.h),
      ],
    );
  }
}