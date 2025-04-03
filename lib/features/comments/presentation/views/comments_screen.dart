import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/comments/models/comments_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/presentation/widgets/post_item.dart';
import '../../../profile/presentation/widgets/build_comments.dart';
import '../widgets/comment_input_field.dart';
import '../widgets/comment_sort_options.dart';

class CommentsScreen extends StatefulWidget {
  final dynamic post;

  const CommentsScreen({super.key, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late List<Comments> comments;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    comments = Comments.generateDummyComments(widget.post.commentCount);
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PostItem(post: widget.post),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.textSecondaryDark,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      const CommentSortOptions(),
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.sort,
                                      size: 16, color: AppColors.textPrimary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Recent',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BuildComments(
                    comments: comments,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    flag: false,
                  ),
                ],
              ),
            ),
          ),
          CommentInputField(
            commentController: _commentController,
            onCommentSubmitted: useless,
          ),
        ],
      ),
    );
  }
}

void useless(String commentText) {}
// void _onCommentSubmitted(String commentText) {
//   if (commentText.isNotEmpty) {
//     setState(() {
//       comments.add(Comments(author: "You", comment: commentText));
//     });
//     _commentController.clear();
//   }
// }

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    backgroundColor: AppColors.backgroundLight,
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: AppColors.backgroundDark),
      onPressed: () => Navigator.pop(context),
    ),
    title: Text(
      'Comments',
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.backgroundDark,
      ),
    ),
  );
}
