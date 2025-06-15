import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../profile/logic/cubit/user_comments_cubit.dart';
import '../../../profile/logic/cubit/user_comments_states.dart';
import '../../data/models/comment_model.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Comment comment;
  final void Function(Comment comment)? onDelete;

  const DeleteConfirmationDialog({
    super.key,
    required this.comment,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userId = comment.author.id;

    return AlertDialog(
      backgroundColor: theme.cardColor,
      title: Text(
        'Delete Comment',
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 19.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this comment?',
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 15.sp,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style:
                TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13.sp),
          ),
        ),
        BlocBuilder<UserCommentsCubit, UserCommentsState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await context
                    .read<UserCommentsCubit>()
                    .deleteComment(userId, comment.id);
                if (onDelete != null) {
                  onDelete!(comment);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                'Delete',
                style: TextStyle(fontSize: 13.sp),
              ),
            );
          },
        ),
      ],
    );
  }
}
