import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/comments/logic/cubit/upvote_comment_cubit.dart';
import 'package:flutterwidgets/features/comments/service/comment_service.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:flutterwidgets/utils/url_helper.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/user_comments_cubit.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/user_comments_states.dart';
import 'package:flutterwidgets/features/profile/service/user_comments.service.dart';
import '../../../../utils/jwt_helper.dart';
import '../../../comments/data/models/comment_model.dart';
import '../../../comments/logic/cubit/comment_cubit.dart';
import '../../../comments/logic/cubit/comment_states.dart';
import '../../../comments/logic/cubit/downvote_comment_cubit.dart';
import '../../../comments/logic/cubit/downvote_comment_states.dart';
import '../../../comments/logic/cubit/upvote_comment_states.dart';
import '../../../comments/views/widgets/profile_avatar.dart';
import '../../../home/views/widgets/vote_button.dart';
import 'comment_content.dart';
import 'delete_confirmation_dialog.dart';
import 'edit_comment_dialog.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final void Function(Comment comment)? onDelete;
  final void Function(Comment comment, String newContent)? onEdit;
  final int nestingLevel;
  final double maxWidth;

  const CommentItem({
    super.key,
    required this.comment,
    this.onDelete,
    this.onEdit,
    this.nestingLevel = 0,
    this.maxWidth = double.infinity,
  });

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isUpVoted = false;
  bool isDownVoted = false;
  bool isExpanded = false;
  bool isMenuVisible = false;
  bool isAuthor = false;
  bool isReplying = false;
  bool isLoadingChildren = false;
  late Color upVoteColor;
  late Color downVoteColor;
  late int voteCounter;
  late TextEditingController replyController;
  List<Comment> children = [];

  // Maximum nesting level to prevent infinite recursion
  static const int maxNestingLevel = 8;

  // Calculate indentation based on nesting level
  double get indentationWidth {
    const baseIndent = 12.0;
    const maxIndent = 40.0;
    return (baseIndent * widget.nestingLevel).clamp(0.0, maxIndent);
  }

  // Calculate available width for content with minimum constraint
  double get availableWidth {
    final screenWidth = MediaQuery.of(context).size.width;
    final totalIndent = indentationWidth + (widget.nestingLevel > 0 ? 16.w : 0);
    final calculatedWidth = (widget.maxWidth == double.infinity ? screenWidth : widget.maxWidth) - totalIndent - 24.w;
    return calculatedWidth.clamp(100.0, double.infinity);
  }

  @override
  void initState() {
    super.initState();
    voteCounter = widget.comment.voteCounter;
    upVoteColor = widget.comment.voteType == "UPVOTE"
        ? const Color(0xFF00E676)
        : Colors.grey;
    downVoteColor = widget.comment.voteType == "DOWNVOTE"
        ? const Color(0xFFFF1744)
        : Colors.grey;
    replyController = TextEditingController();
    _checkIfAuthor();
    if (widget.comment.parentId != null || widget.comment.hasChildren) {
      widget.comment.hasChildren = true;
    }
  }

  Future<void> _checkIfAuthor() async {
    final userId = await getUserId();
    if (mounted) {
      setState(() {
        isAuthor = userId == widget.comment.author.id;
      });
    }
  }

  Future<dynamic> getUserId() async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      return getUserIdFromToken(token);
    }
    return null;
  }

  Future<void> _loadChildren() async {
    if (isLoadingChildren || children.isNotEmpty) return;
    setState(() {
      isLoadingChildren = true;
    });
    try {
      final fetchedChildren = await context.read<CommentCubit>().fetchCommentChildren(widget.comment.id);
      if (mounted) {
        setState(() {
          children = fetchedChildren;
          isLoadingChildren = false;
          if (fetchedChildren.isNotEmpty) {
            widget.comment.hasChildren = true;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingChildren = false;
        });
      }
    }
  }

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded && children.isEmpty && widget.comment.hasChildren) {
        _loadChildren();
      }
    });
  }

  void _toggleReply() {
    setState(() {
      isReplying = !isReplying;
      if (!isReplying) {
        replyController.clear();
      }
    });
  }

  void _submitReply() {
    final content = replyController.text.trim();
    if (content.isEmpty) return;

    context.read<CommentCubit>().createComment(
      content,
      widget.comment.postId,
      widget.comment.id,
    ).then((_) {
      if (mounted) {
        replyController.clear();
        setState(() {
          isReplying = false;
        });
      }
    });
  }

  void _toggleMenu() {
    setState(() {
      isMenuVisible = !isMenuVisible;
    });
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => EditCommentDialog(
        comment: widget.comment,
        onEdit: widget.onEdit,
      ),
    );
  }

  void _showDeleteDialog() {
    setState(() {
      isMenuVisible = false;
    });
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        comment: widget.comment,
        onDelete: widget.onDelete,
      ),
    );
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    return MultiBlocProvider(
      providers: [
        BlocProvider<UpvoteCommentCubit>(
          create: (context) => UpvoteCommentCubit(CommentService()),
        ),
        BlocProvider<DownvoteCommentCubit>(
          create: (context) => DownvoteCommentCubit(CommentService()),
        ),
        BlocProvider<UserCommentsCubit>(
          create: (context) => UserCommentsCubit(UserCommentsApiService()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<UserCommentsCubit, UserCommentsState>(
            listener: (context, state) {
              if (state is UserCommentsError && mounted) {
                // Ensure ScaffoldMessenger is used with a valid Scaffold context
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
          BlocListener<CommentCubit, CommentStates>(
            listener: (context, state) {
              if (state is CommentCreated && state.comment.parentId == widget.comment.id) {
                setState(() {
                  children = [state.comment, ...children];
                  widget.comment.hasChildren = true;
                  isExpanded = true;
                });
              }
            },
          ),
        ],
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CommentContent(
              comment: comment,
              nestingLevel: widget.nestingLevel,
              maxWidth: widget.maxWidth,
              isExpanded: isExpanded,
              isReplying: isReplying,
              isAuthor: isAuthor,
              isMenuVisible: isMenuVisible,
              isLoadingChildren: isLoadingChildren,
              children: children,
              upVoteColor: upVoteColor,
              downVoteColor: downVoteColor,
              voteCounter: voteCounter,
              replyController: replyController,
              onToggleExpanded: _toggleExpanded,
              onToggleReply: _toggleReply,
              onSubmitReply: _submitReply,
              onToggleMenu: _toggleMenu,
              onShowEditDialog: _showEditDialog,
              onShowDeleteDialog: _showDeleteDialog,
            );
          },
        ),
      ),
    );
  }
}
