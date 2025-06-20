import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../profile/views/widgets/comment_item.dart';
import '../../data/models/comment_model.dart';

class RepliesSection extends StatelessWidget {
  final int nestingLevel;
  final double maxWidth;
  final bool isLoadingChildren;
  final List<Comment> children;
  final Comment comment;
  final void Function(Comment comment)? onDelete;
  final void Function(Comment comment, String newContent)? onEdit;

  const RepliesSection({
    super.key,
    required this.nestingLevel,
    required this.maxWidth,
    required this.isLoadingChildren,
    required this.children,
    required this.comment,
    this.onDelete,
    this.onEdit,
  });

  double get indentationWidth {
    const baseIndent = 12.0;
    const maxIndent = 40.0;
    return (baseIndent * nestingLevel).clamp(0.0, maxIndent);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoadingChildren)
            Container(
              margin: EdgeInsets.only(left: indentationWidth + 18.w),
              padding: EdgeInsets.all(14.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: const CupertinoActivityIndicator(),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Loading replies...',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            )
          else if (children.isEmpty && comment.hasChildren)
            Container(
              margin: EdgeInsets.only(left: indentationWidth + 18.w),
              padding: EdgeInsets.all(14.h),
              child: Text(
                'No replies available',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            )
          else
            ...children
                .map((child) => CommentItem(
                      comment: comment,
                      onDelete: onDelete,
                      onEdit: onEdit,
                      nestingLevel: nestingLevel + 1,
                      maxWidth: maxWidth,
                    ))
                .toList(),
        ],
      ),
    );
  }
}
