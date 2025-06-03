import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../profile/presentation/widgets/build_comments.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:   EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical:  12.w
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Comments (${comments.length})',
                style: GoogleFonts.poppins(
                  fontSize:  18.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (comments.isEmpty)
          Center(
            child: Padding(
              padding:   EdgeInsets.all(20.0.w),
              child: Text(
                'No comments yet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          )
        else ...[
            Divider(height: 1.h),
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
