import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/comment_model.dart';

class CommentText extends StatelessWidget {
  final Comment comment;
  final double maxWidth;

  const CommentText({
    super.key,
    required this.comment,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: maxWidth,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        comment.content ?? '',
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 14.sp,
          height: 1.4,
        ),
        softWrap: true,
      ),
    );
  }
}