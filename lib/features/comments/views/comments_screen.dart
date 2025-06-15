import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/comments/logic/cubit/comment_states.dart';
import 'package:flutterwidgets/features/comments/views/widgets/comment_input_field.dart';
import 'package:flutterwidgets/utils/loading_state.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/error_state.dart';
import '../../home/data/models/post_model.dart';
import '../../home/logic/cubit/post_feed_cubit.dart';
import '../../home/views/widgets/post_item.dart';
import '../../profile/views/widgets/build_comments.dart';
import '../logic/cubit/comment_cubit.dart';

class CommentsScreen extends StatefulWidget {
  final dynamic post;

  const CommentsScreen({super.key, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late TextEditingController _commentController;
  late Post post;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    fetchComments();
    post = widget.post;
  }

  void fetchComments() {
    context.read<CommentCubit>().fetchComments(widget.post.id);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onCommentSubmitted(String text) {
    if (text.trim().isEmpty) return;

    final cubit = context.read<CommentCubit>();
    cubit.createComment(text.trim(), widget.post.id, null).then((_) {
      _commentController.clear();
      final updatedPost = Post(
        id: widget.post.id,
        title: widget.post.title,
        content: widget.post.content,
        author: widget.post.author,
        createdAt: widget.post.createdAt,
        updatedAt: widget.post.updatedAt,
        voteCounter: widget.post.voteCounter,
        voteType: widget.post.voteType,
        commentCount: widget.post.commentCount + 1,
        attachments: widget.post.attachments,
        forumId: widget.post.forumId,
      );
      context.read<PostFeedCubit>().updatePost(updatedPost);
      setState(() {
        post = updatedPost;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<CommentCubit>()
            .fetchComments(widget.post.id, forceRefresh: true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
                      padding: EdgeInsets.all(8.0.w),
                      child: PostItem(
                        post: post,
                      ),
                    ),
                    BlocBuilder<CommentCubit, CommentStates>(
                      builder: (BuildContext context, CommentStates state) {
                        if (state is CommentLoading) {
                          return const Center(
                            child: LoadingState(),
                          );
                        } else if (state is CommentError) {
                          return Center(
                              child: ErrorStateWidget(
                            message: state.message,
                            onRetry: () => context
                                .read<CommentCubit>()
                                .fetchComments(widget.post.id),
                          ));
                        } else if (state is CommentsFetched) {
                          return Column(
                            children: [
                              BuildComments(
                                comments: state.comments,
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                onDelete: (comment) {
                                  context
                                      .read<CommentCubit>()
                                      .emit(CommentLoading());
                                  context
                                      .read<CommentCubit>()
                                      .fetchComments(post.id);
                                },
                                onEdit: (comment, newContent) => context
                                    .read<CommentCubit>()
                                    .fetchComments(post.id),
                              ),
                            ],
                          );
                        } else if (state is CommentCreated) {
                          return const SizedBox.shrink();
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
            CommentInputField(
              commentController: _commentController,
              createComment: _onCommentSubmitted,
            ),
          ],
        ),
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
