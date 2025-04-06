import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/comments/models/comments_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/models/author_model.dart';
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
  late Author currentUser;

  @override
  void initState() {
    super.initState();
    comments = Comments.generateDummyComments(widget.post.commentCount);
    _commentController = TextEditingController();
    currentUser = Author.users[0]; // Using the first user as the current user
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onCommentSubmitted(String commentText) {
    if (commentText.isNotEmpty) {
      final newComment = Comments(
        author: currentUser.name,
        comment: commentText,
        repliedTo: "", // No reply in this case
        voteCount: 0,
        upvote: 0,
        downVote: 0,
        avatar: currentUser.avatar,
        time: 0, // Just now
        communityName: widget.post.communityName,
        communityImage: widget.post.communityImage,
      );
      
      setState(() {
        comments.insert(0, newComment);
      });
      
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceVariant,
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
                                  Icon(Icons.sort,
                                      size: 16, color: colorScheme.onSurface),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Recent',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: colorScheme.onSurface,
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
            onCommentSubmitted: _onCommentSubmitted,
            currentUser: currentUser,
          ),
        ],
      ),
    );
  }
}

AppBar _buildAppBar(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  
  return AppBar(
    elevation: 0,
    backgroundColor: theme.scaffoldBackgroundColor,
    centerTitle: true,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
      onPressed: () => Navigator.pop(context),
    ),
    title: Text(
      'Comments',
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    ),
  );
}
