import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:video_player/video_player.dart';
import 'guideline.dart';
import 'join_button.dart';

class InfoTab extends StatelessWidget {
  final Community community;
  final String Function(Duration) formatDuration;
  final VoidCallback onJoinToggle;

  const InfoTab({
    super.key,
    required this.community,
    required this.formatDuration,
    required this.onJoinToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Text(
          'About this Community',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          community.bio,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5.h,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Tags',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.w,
          children: List<Widget>.from(community.Tags.map((tag) {
            return Chip(
              label: Text(tag.name),
              backgroundColor: theme.colorScheme.surface,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
            );
          })),
        ),
        SizedBox(height: 24.h),
        Text(
          'Community Guidelines',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        const Guideline(
          icon: Icons.check_circle_outline,
          title: 'Be Respectful',
          description: 'Treat others with kindness and respect.',
        ),
        const Guideline(
          icon: Icons.check_circle_outline,
          title: 'Share Knowledge',
          description: 'Contribute valuable content to the community.',
        ),
        const Guideline(
          icon: Icons.check_circle_outline,
          title: 'Stay On Topic',
          description: 'Keep discussions relevant to the community focus.',
        ),
      ],
    );
  }
}