import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/comments/logic/cubit/comment_states.dart';
import 'package:flutterwidgets/features/comments/models/comments_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/models/author_model.dart';
import '../../../home/presentation/widgets/post_item.dart';
import '../../../profile/presentation/widgets/build_comments.dart';
import '../../logic/cubit/comment_cubit.dart';
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
    currentUser = Author.users[0];
    context.read<CommentCubit>().fetchComments(widget.post.id);

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
        repliedTo: "",
        voteCount: 0,
        upvote: 0,
        downVote: 0,
        avatar: currentUser.avatar,
        time: 0,
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
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: BlocBuilder<CommentCubit, CommentStates>(
        builder: (BuildContext context, CommentStates state) {
          if(state is CommentLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is CommentsFetched) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0.w),
                          child: PostItem(
                            post: widget.post,
                            isUserPost: false,
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.w),
                          child: Padding(
                            padding: EdgeInsets.all(8.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Comments (${state.comments.length})',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BuildComments(
                          comments: state.comments,
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
            );
          } else if (state is CommentError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          else {
            return Center(child: Text('No comments available'));
          }
        },
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
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    ),
  );
}
