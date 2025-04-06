import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/core/utils/responsive_utils.dart';
import '../../../profile/presentation/widgets/build_comments.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../profile/models/user_comments_model.dart';
import '../../models/comments_model.dart';

class CommentsList extends StatelessWidget {
  final List<Comments> comments;

  const CommentsList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 16, 
            vertical: isMobile ? 8 : 12
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Comments (${comments.length})',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        BuildComments(
          comments: comments,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          flag: false,
        ),
      ],
    );
  }
}
