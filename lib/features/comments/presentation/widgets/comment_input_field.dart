import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentInputField extends StatelessWidget {
  final TextEditingController commentController;
  final Function(String) onCommentSubmitted;

  const CommentInputField({
    super.key,
    required this.commentController,
    required this.onCommentSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary,
            blurRadius: 20,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.jpg'),
              radius: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    IconButton(
                      icon:
                      const Icon(Icons.photo_outlined, color:AppColors.primary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.buttonGradient,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: AppColors.backgroundLight),
                onPressed: () {
                  if (commentController.text.isNotEmpty) {
                    commentController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
