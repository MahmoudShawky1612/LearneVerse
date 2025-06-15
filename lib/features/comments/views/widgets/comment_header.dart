import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/comments/views/widgets/profile_avatar.dart';

import '../../data/models/comment_model.dart';

class CommentHeader extends StatelessWidget {
  final Comment comment;
  final bool isAuthor;
  final VoidCallback onToggleMenu;

  const CommentHeader({
    super.key,
    required this.comment,
    required this.isAuthor,
    required this.onToggleMenu,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28.r,
          height: 28.r,
          child: ProfileAvatar(comment: comment),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                 mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      comment.author.fullname.isNotEmpty
                          ? comment.author.fullname
                          : 'Anonymous User',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '• ${_getTimeAgo(comment.createdAt)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 11.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isAuthor)
          InkWell(
            onTap: onToggleMenu,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.all(5.r),
              child: Icon(
                Icons.more_horiz,
                color: colorScheme.onSurface.withOpacity(0.7),
                size: 18.r,
              ),
            ),
          ),
      ],
    );
  }

  String _getTimeAgo(DateTime createdAt) {
    final now = DateTime.now().toUtc();
    final created = createdAt.toUtc();
    final difference = now.difference(created);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
