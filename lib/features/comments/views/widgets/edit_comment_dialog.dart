import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/url_helper.dart';
import '../../../profile/logic/cubit/user_comments_cubit.dart';
import '../../data/models/comment_model.dart';

class EditCommentDialog extends StatelessWidget {
  final Comment comment;
  final void Function(Comment comment, String newContent)? onEdit;

  const EditCommentDialog({
    super.key,
    required this.comment,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userId = comment.author.id;
    final controller = TextEditingController(text: comment.content ?? '');

    return AlertDialog(
      backgroundColor: theme.cardColor,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: comment.author.userProfile?.profilePictureURL != null
                ? CachedNetworkImageProvider(
                UrlHelper.transformUrl(comment.author.userProfile!.profilePictureURL!))
                : null,
            radius: 18.r,
            backgroundColor: colorScheme.primary.withOpacity(0.1),
            child: comment.author.userProfile?.profilePictureURL == null
                ? Icon(
              Icons.person,
              size: 20.r,
              color: colorScheme.primary,
            )
                : null,
          ),
          SizedBox(width: 12.w),
          Text(
            'Edit Comment',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controller,
              maxLines: 4,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: 'Edit your comment...',
                hintStyle: TextStyle(color: theme.hintColor, fontSize: 13.sp),
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor ?? theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13.sp),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<UserCommentsCubit>().updateComment(
              userId,
              comment.id,
              controller.text.trim(),
            );
            Navigator.pop(context);
            if (onEdit != null) {
              onEdit!(comment, controller.text.trim());
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: Text(
            'Update',
            style: TextStyle(fontSize: 13.sp),
          ),
        ),
      ],
    );
  }
}