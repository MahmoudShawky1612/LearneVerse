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
import '../../../comments/logic/cubit/downvote_comment_cubit.dart';
import '../../../comments/logic/cubit/downvote_comment_states.dart';
import '../../../comments/logic/cubit/upvote_comment_states.dart';
import '../../../comments/views/widgets/profile_avatar.dart';
import '../../../home/views/widgets/vote_button.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final void Function(Comment comment)? onDelete;
  final void Function(Comment comment, String newContent)? onEdit;

  const CommentItem({
    super.key,
    required this.comment,
    this.onDelete,
    this.onEdit,
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
      _loadChildren();
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
    if (isLoadingChildren) return;
    setState(() {
      isLoadingChildren = true;
    });
    try {
      final fetchedChildren = await context.read<CommentCubit>().fetchCommentChildren(widget.comment.id);
      setState(() {
        children = fetchedChildren;
        isLoadingChildren = false;
        if (fetchedChildren.isNotEmpty) {
          widget.comment.hasChildren = true;
        }
      });
    } catch (e) {
      setState(() {
        isLoadingChildren = false;
      });
    }
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
      replyController.clear();
      setState(() {
        isReplying = false;
      });
      _loadChildren();
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
      child: BlocListener<UserCommentsCubit, UserCommentsState>(
        listener: (context, state) {
          if (state is UserCommentsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Container(
          margin: EdgeInsets.only(
            left: comment.parentId != null ? 16.w : 0,
            bottom: 8.h,
          ),
          decoration: BoxDecoration(
            border: comment.parentId != null
                ? Border(
                    left: BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                      width: 2.w,
                    ),
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileAvatar(comment: comment),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                        fontSize: 13.sp,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '${_getTimeAgo(comment.createdAt)} ago',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        isAuthor
                            ? _buildOptionsButton(colorScheme)
                            : const SizedBox.shrink(),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.only(left: 36.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCommentContent(comment, textTheme, colorScheme),
                          SizedBox(height: 8.h),
                          _buildVotingRow(comment),
                          if (isReplying) ...[
                            SizedBox(height: 12.h),
                            _buildReplyInput(colorScheme),
                          ],
                          if (isAuthor && isMenuVisible)
                            _buildOptionsMenu(colorScheme),
                          if (isExpanded && (comment.hasChildren || children.isNotEmpty)) ...[
                            SizedBox(height: 12.h),
                            if (isLoadingChildren)
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        colorScheme.primary),
                                  ),
                                ),
                              )
                            else if (children.isEmpty)
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Text(
                                    'No replies yet',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              )
                            else
                              ...children.map((child) => CommentItem(
                                    comment: child,
                                    onDelete: widget.onDelete,
                                    onEdit: widget.onEdit,
                                  )),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsButton(ColorScheme colorScheme) {
    return IconButton(
      icon: Icon(
        Icons.more_horiz,
        color: colorScheme.onSurface.withOpacity(0.8),
        size: 18.r,
      ),
      onPressed: () {
        setState(() {
          isMenuVisible = !isMenuVisible;
        });
      },
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: 20.w,
        minHeight: 20.w,
      ),
    );
  }

  Widget _buildOptionsMenu(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.2),
            blurRadius: 4.r,
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
            height: 8.h,
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

  Widget _buildCommentContent(
      Comment comment, TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        comment.content ?? '',
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 14.sp,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildVotingRow(Comment comment) {
    return Row(
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
            return EnhancedVoteButton(
              icon: Icons.arrow_circle_up_rounded,
              color: upVoteColor,
              isLoading: state is UpVoteCommentLoading,
              isUpvote: true,
              onTap: () =>
                  context.read<UpvoteCommentCubit>().upVoteComment(comment),
            );
          },
        ),
        SizedBox(width: 4.w),
        Text(
          '$voteCounter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(width: 10.w),
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
            return EnhancedVoteButton(
              icon: Icons.arrow_circle_down_rounded,
              color: downVoteColor,
              isLoading: state is DownVoteCommentLoading,
              isUpvote: false,
              onTap: () =>
                  context.read<DownvoteCommentCubit>().downVoteComment(comment),
            );
          },
        ),
        SizedBox(width: 20.w),
        _buildActionButton(
          icon: Icons.reply_rounded,
          text: 'Reply',
          onTap: _toggleReply,
        ),
        if (comment.hasChildren || children.isNotEmpty) ...[
          SizedBox(width: 20.w),
          _buildActionButton(
            icon: isExpanded ? Icons.expand_less : Icons.expand_more,
            text: isExpanded ? 'Hide replies' : 'Show replies',
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
                if (isExpanded && children.isEmpty) {
                  _loadChildren();
                }
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: Colors.grey[600]),
          SizedBox(width: 4.w),
          Text(text,
              style: TextStyle(color: Colors.grey[700], fontSize: 13.sp)),
        ],
      ),
    );
  }

  Widget _buildReplyInput(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
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
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8.h),
              ),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14.sp,
              ),
              maxLines: null,
            ),
          ),
          IconButton(
            onPressed: _submitReply,
            icon: Icon(
              Icons.send_rounded,
              color: colorScheme.primary,
              size: 20.r,
            ),
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
      borderRadius: BorderRadius.circular(4.r),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 12.w,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.r,
              color: color,
            ),
            SizedBox(width: 8.w),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
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
    final now = DateTime.now();
    final difference = now.difference(createdAt);

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
