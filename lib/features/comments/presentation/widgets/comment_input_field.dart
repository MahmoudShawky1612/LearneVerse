import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/models/author_model.dart';

class CommentInputField extends StatelessWidget {
  final TextEditingController commentController;
  final void Function(String) onCommentSubmitted;
  final Author currentUser;

  const CommentInputField({
    Key? key,
    required this.commentController,
    required this.onCommentSubmitted,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = theme.extension<AppThemeExtension>();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
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
            radius: 18,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: commentController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                hintStyle: TextStyle(
                  color: theme.hintColor,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: theme.cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          GestureDetector(
            onTap: () {
              onCommentSubmitted(commentController.text);
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                gradient: themeExtension?.buttonGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
