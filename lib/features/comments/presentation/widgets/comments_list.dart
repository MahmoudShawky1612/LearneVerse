import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/core/utils/responsive_utils.dart';
import '../../../profile/presentation/widgets/build_comments.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../profile/models/user_comments_model.dart';
import '../../models/comments_model.dart';

class CommentsList extends StatelessWidget {
  final List<Comments> comments;
  final Function? delete;

  const CommentsList({
    super.key, 
    required this.comments,
    this.delete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 16, 
            vertical: isMobile ? 10 : 12
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Comments (${comments.length})',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ),
        if (comments.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'No comments yet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          )
        else ...[
          const Divider(height: 1),
          Expanded(
            child: BuildComments(
              comments: comments,
              scrollPhysics: const AlwaysScrollableScrollPhysics(),
              flag: false,
              delete: delete,
            ),
          ),
        ],
      ],
    );
  }
}
