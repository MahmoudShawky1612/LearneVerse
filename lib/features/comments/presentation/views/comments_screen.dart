import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/comments/logic/cubit/comment_states.dart';
import 'package:flutterwidgets/features/comments/models/comments_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/data/models/post_model.dart';
import '../../../home/presentation/widgets/post_item.dart';
import '../../../profile/presentation/widgets/build_comments.dart';
import '../../logic/cubit/comment_cubit.dart';
import '../widgets/comment_input_field.dart';

class CommentsScreen extends StatefulWidget {
  final dynamic post;

  const CommentsScreen({super.key, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late List<Comments> comments;
  late TextEditingController _commentController;
  late Post post;

  @override
  void initState() {
    super.initState();
    comments = Comments.generateDummyComments(widget.post.commentCount);
    _commentController = TextEditingController();
    context.read<CommentCubit>().fetchComments(widget.post.id);
    post = widget.post;
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
      cubit.fetchComments(widget.post.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
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
                          child: CupertinoActivityIndicator(),
                        );
                      } else if (state is CommentError) {
                        return Center(
                          child: Text(
                            'Error: ${state.message}',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              color: colorScheme.error,
                            ),
                          ),
                        );
                      } else if (state is CommentsFetched) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.w),
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
                            ),
                          ],
                        );
                      }
                      // Add a default return to avoid "body might complete normally" error
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