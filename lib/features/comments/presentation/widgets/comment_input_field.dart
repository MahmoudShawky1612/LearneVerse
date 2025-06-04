import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/models/author_model.dart';

class CommentInputField extends StatelessWidget {
  final TextEditingController commentController;
  final void Function(String) onCommentSubmitted;
  final Author currentUser;

  const CommentInputField({
    super.key,
    required this.commentController,
    required this.onCommentSubmitted,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = theme.extension<AppThemeExtension>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0.w,
        vertical: 8.0.w,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -4),
            blurRadius: 8,
            color: colorScheme.primary.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(currentUser.avatar),
            radius: 18.r,
          ),
          SizedBox(width: 8.0.w),
          Expanded(
            child: TextField(
              controller: commentController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                hintStyle: TextStyle(
                  color: theme.hintColor,
                  fontSize: 14.sp,
                ),
                filled: true,
                fillColor: theme.cardColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                  vertical: 8.0.w,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0.w),
          GestureDetector(
            onTap: () {
              onCommentSubmitted(commentController.text);
            },
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                gradient: themeExtension?.buttonGradient,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
