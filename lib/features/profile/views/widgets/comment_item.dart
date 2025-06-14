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

  // Calculate available width for content
  double get availableWidth {
    final screenWidth = MediaQuery.of(context).size.width;
    final totalIndent = indentationWidth + (widget.nestingLevel > 0 ? 16.w : 0);
    return (widget.maxWidth == double.infinity ? screenWidth : widget.maxWidth) - totalIndent - 24.w;
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

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
              if (state is UserCommentsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
          BlocListener<CommentCubit, CommentStates>(
            listener: (context, state) {
              if (state is CommentCreated) {
                if (state.comment.parentId == widget.comment.id) {
                  setState(() {
                    children = [state.comment, ...children];
                    widget.comment.hasChildren = true;
                    isExpanded = true; // Auto-expand when new reply is added
                  });
                }
              }
            },
          ),
        ],
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main comment content
                  _buildCommentContent(comment, textTheme, colorScheme, constraints),

                  // Nested replies
                  if (isExpanded && widget.nestingLevel < maxNestingLevel)
                    _buildRepliesSection(constraints),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCommentContent(Comment comment, TextTheme textTheme, ColorScheme colorScheme, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      margin: EdgeInsets.only(
        left: widget.nestingLevel > 0 ? indentationWidth : 0,
        bottom: 4.h,
      ),
      decoration: BoxDecoration(
        border: widget.nestingLevel > 0
            ? Border(
          left: BorderSide(
            color: _getThreadLineColor(colorScheme),
            width: 2.w,
          ),
        )
            : null,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: widget.nestingLevel > 0 ? 12.w : 16.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row
            _buildCommentHeader(comment, textTheme, colorScheme, constraints),

            SizedBox(height: 8.h),

            // Comment text content
            _buildCommentText(comment, textTheme, colorScheme, constraints),

            SizedBox(height: 8.h),

            // Actions row (vote, reply, etc.)
            _buildActionsRow(comment, constraints),

            // Reply input
            if (isReplying) ...[
              SizedBox(height: 12.h),
              _buildReplyInput(colorScheme, constraints),
            ],

            // Options menu
            if (isAuthor && isMenuVisible)
              _buildOptionsMenu(colorScheme, constraints),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentHeader(Comment comment, TextTheme textTheme, ColorScheme colorScheme, BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        Container(
          width: 24.r,
          height: 24.r,
          child: ProfileAvatar(comment: comment),
        ),

        SizedBox(width: 8.w),

        // User info and timestamp
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      comment.author.fullname.isNotEmpty
                          ? comment.author.fullname
                          : 'Anonymous User',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '• ${_getTimeAgo(comment.createdAt)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Options button for author
        if (isAuthor) _buildOptionsButton(colorScheme),
      ],
    );
  }

  Widget _buildCommentText(Comment comment, TextTheme textTheme, ColorScheme colorScheme, BoxConstraints constraints) {
    final maxWidth = constraints.maxWidth - (widget.nestingLevel > 0 ? indentationWidth + 16.w : 32.w);

    return Container(
      width: maxWidth,
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        comment.content ?? '',
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 13.sp,
          height: 1.3,
        ),
        softWrap: true,
      ),
    );
  }

  Widget _buildActionsRow(Comment comment, BoxConstraints constraints) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 4.h,
      children: [
        // Voting buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocConsumer<UpvoteCommentCubit, UpVoteCommentStates>(
              listener: (context, state) {
                if (state is UpVoteCommentSuccess) {
                  setState(() {
                    voteCounter = comment.voteCounter;
                    upVoteColor = comment.voteType == "UPVOTE"
                        ? const Color(0xFF00E676)
                        : Colors.grey;
                    downVoteColor = Colors.grey;
                  });
                }
              },
              builder: (context, state) {
                return _buildCompactVoteButton(
                  icon: Icons.arrow_upward,
                  color: upVoteColor,
                  isLoading: state is UpVoteCommentLoading,
                  onTap: () => context.read<UpvoteCommentCubit>().upVoteComment(comment),
                );
              },
            ),

            SizedBox(width: 4.w),

            Text(
              '$voteCounter',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),

            SizedBox(width: 4.w),

            BlocConsumer<DownvoteCommentCubit, DownVoteCommentStates>(
              listener: (context, state) {
                if (state is DownVoteCommentSuccess) {
                  setState(() {
                    voteCounter = comment.voteCounter;
                    downVoteColor = comment.voteType == "DOWNVOTE"
                        ? const Color(0xFFFF1744)
                        : Colors.grey;
                    upVoteColor = Colors.grey;
                  });
                }
              },
              builder: (context, state) {
                return _buildCompactVoteButton(
                  icon: Icons.arrow_downward,
                  color: downVoteColor,
                  isLoading: state is DownVoteCommentLoading,
                  onTap: () => context.read<DownvoteCommentCubit>().downVoteComment(comment),
                );
              },
            ),
          ],
        ),

        // Reply button
        _buildCompactActionButton(
          icon: Icons.reply,
          text: 'Reply',
          onTap: _toggleReply,
        ),

        // Show/Hide replies button
        if (comment.hasChildren || children.isNotEmpty)
          _buildCompactActionButton(
            icon: isExpanded ? Icons.expand_less : Icons.expand_more,
            text: isExpanded
                ? 'Hide ${children.length} ${children.length == 1 ? 'reply' : 'replies'}'
                : 'Show replies',
            onTap: _toggleExpanded,
          ),
      ],
    );
  }

  Widget _buildRepliesSection(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoadingChildren)
            Container(
              margin: EdgeInsets.only(left: indentationWidth + 16.w),
              padding: EdgeInsets.all(12.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16.r,
                    height: 16.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Loading replies...',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            )
          else if (children.isEmpty && widget.comment.hasChildren)
            Container(
              margin: EdgeInsets.only(left: indentationWidth + 16.w),
              padding: EdgeInsets.all(12.h),
              child: Text(
                'No replies available',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            )
          else
            ...children.map((child) => CommentItem(
              comment: child,
              onDelete: widget.onDelete,
              onEdit: widget.onEdit,
              nestingLevel: widget.nestingLevel + 1,
              maxWidth: constraints.maxWidth,
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildCompactVoteButton({
    required IconData icon,
    required Color color,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(4.r),
        child: isLoading
            ? SizedBox(
          width: 12.r,
          height: 12.r,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        )
            : Icon(
          icon,
          size: 14.r,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCompactActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13.r,
              color: Colors.grey[600],
            ),
            SizedBox(width: 3.w),
            Text(
              text,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyInput(ColorScheme colorScheme, BoxConstraints constraints) {
    final maxWidth = constraints.maxWidth - (widget.nestingLevel > 0 ? indentationWidth + 16.w : 32.w);

    return Container(
      width: maxWidth,
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: replyController,
              decoration: InputDecoration(
                hintText: 'Write a reply...',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                isDense: true,
              ),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 12.sp,
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            onPressed: _submitReply,
            icon: Icon(
              Icons.send,
              color: colorScheme.primary,
              size: 16.r,
            ),
            constraints: BoxConstraints(
              minWidth: 32.w,
              minHeight: 32.w,
            ),
            padding: EdgeInsets.all(4.r),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsButton(ColorScheme colorScheme) {
    return InkWell(
      onTap: () {
        setState(() {
          isMenuVisible = !isMenuVisible;
        });
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(4.r),
        child: Icon(
          Icons.more_horiz,
          color: colorScheme.onSurface.withOpacity(0.7),
          size: 16.r,
        ),
      ),
    );
  }

  Widget _buildOptionsMenu(ColorScheme colorScheme, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: 6.h),
      constraints: BoxConstraints(
        maxWidth: (constraints.maxWidth * 0.6).clamp(120.0, 200.0),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.15),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOptionsItem(
            'Edit',
            Icons.edit_outlined,
            colorScheme.primary,
                () => _showEditCommentDialog(widget.comment.content ?? ''),
          ),
          Divider(
            height: 1.h,
            color: colorScheme.onSurface.withOpacity(0.1),
          ),
          _buildOptionsItem(
            'Delete',
            Icons.delete_outline,
            colorScheme.error,
                () {
              setState(() {
                isMenuVisible = false;
              });
              _showDeleteConfirmationDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsItem(
      String text,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: () {
        setState(() {
          isMenuVisible = false;
        });
        onTap();
      },
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 12.w,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14.r,
              color: color,
            ),
            SizedBox(width: 8.w),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getThreadLineColor(ColorScheme colorScheme) {
    // Different colors for different nesting levels (like Reddit)
    final colors = [
      colorScheme.primary.withOpacity(0.3),
      colorScheme.secondary.withOpacity(0.3),
      colorScheme.tertiary.withOpacity(0.3),
      colorScheme.error.withOpacity(0.3),
      colorScheme.outline.withOpacity(0.3),
    ];
    return colors[widget.nestingLevel % colors.length];
  }

  void _showEditCommentDialog(String content) {
    final comment = widget.comment;
    final userId = widget.comment.author.id;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        TextEditingController commentController =
        TextEditingController(text: content);

        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                comment.author.userProfile?.profilePictureURL != null
                    ? CachedNetworkImageProvider(UrlHelper.transformUrl(
                    comment.author.userProfile!.profilePictureURL!))
                    : null,
                radius: 16.r,
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                child: comment.author.userProfile?.profilePictureURL == null
                    ? Icon(
                  Icons.person,
                  size: 18.r,
                  color: colorScheme.primary,
                )
                    : null,
              ),
              SizedBox(width: 10.w),
              Text(
                'Edit Comment',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: commentController,
                  maxLines: 4,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Edit your comment...',
                    hintStyle: TextStyle(color: theme.hintColor),
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor ??
                        theme.scaffoldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<UserCommentsCubit>().updateComment(
                  userId,
                  comment.id,
                  commentController.text.trim(),
                );
                Navigator.pop(context);
                if (widget.onEdit != null) {
                  widget.onEdit!(comment, commentController.text.trim());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() async {
    final userId = widget.comment.author.id;
    await showDialog<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: Text(
            'Delete Comment',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this comment?',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            BlocBuilder<UserCommentsCubit, UserCommentsState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await context
                        .read<UserCommentsCubit>()
                        .deleteComment(userId, widget.comment.id);
                    if (widget.onDelete != null) {
                      widget.onDelete!(widget.comment);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text('Delete'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _getTimeAgo(DateTime createdAt) {
    final now = DateTime.now().toUtc();
    final created = createdAt.toUtc();
    final difference = now.difference(created);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}