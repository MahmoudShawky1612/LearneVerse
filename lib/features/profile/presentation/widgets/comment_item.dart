import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/comments/logic/cubit/upvote_comment_cubit.dart';
import 'package:flutterwidgets/features/comments/services/comment_service.dart';
import 'package:flutterwidgets/utils/url_helper.dart';
import 'package:go_router/go_router.dart';

import '../../../comments/data/models/comment_model.dart';
import '../../../comments/logic/cubit/downvote_comment_cubit.dart';
import '../../../comments/logic/cubit/downvote_comment_states.dart';
import '../../../comments/logic/cubit/upvote_comment_states.dart';
import '../../../home/presentation/widgets/vote_button.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final dynamic userInfo;
  final Function? delete;
  final Function? edit;
  final bool? flag;

  const CommentItem({
    super.key,
    required this.comment,
    this.userInfo,
    this.delete,
    this.edit,
    this.flag,
  });

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isUpVoted = false;
  bool isDownVoted = false;
  bool isExpanded = false;
  bool showOptions = false;
  late Color upVoteColor;
  late Color downVoteColor;
  late int voteCounter;

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
    print('Vote Counter: ${widget.comment.voteCounter}');
    print('Vote Type: ${widget.comment.voteType}');
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
      ],
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
                    _buildProfileAvatar(comment),
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
                    _buildOptionsButton(colorScheme),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(Comment comment) {
    return GestureDetector(
      onTap: () => context.push('/profile', extra: comment.author.id),
      child: CircleAvatar(
        radius: 14.r,
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: _getAvatarContent(comment),
      ),
    );
  }

  Widget _getAvatarContent(Comment comment) {
    final profilePictureURL = comment.author.userProfile?.profilePictureURL;

    if (profilePictureURL != null && profilePictureURL.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          UrlHelper.transformUrl(profilePictureURL),
          width: 28.r,
          height: 28.r,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _getDefaultAvatar();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: 28.r,
              height: 28.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
        ),
      );
    } else {
      return _getDefaultAvatar();
    }
  }

  Widget _getDefaultAvatar() {
    return Icon(
      Icons.person,
      size: 16.r,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildOptionsButton(ColorScheme colorScheme) {
    if (widget.flag != true) return const SizedBox.shrink();

    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: colorScheme.onSurface.withOpacity(0.8),
            size: 18.r,
          ),
          onPressed: () {
            setState(() {
              showOptions = !showOptions;
            });
          },
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: 20.w,
            minHeight: 20.w,
          ),
        ),
        if (showOptions) _buildOptionsMenu(colorScheme),
      ],
    );
  }

  Widget _buildOptionsMenu(ColorScheme colorScheme) {
    return Positioned(
      right: 30.w,
      top: 30.h,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.r),
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
                    showOptions = false;
                  });
                  if (widget.delete != null) {
                    Future.delayed(Duration.zero, () {
                      widget.delete!(widget.comment.id);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentContent(Comment comment, TextTheme textTheme, ColorScheme colorScheme) {
    final content = comment.content;

    if (content == null || content.isEmpty) {
      return Text(
        '[No content]',
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 14.sp,
          color: colorScheme.onSurface.withOpacity(0.5),
          fontStyle: FontStyle.italic,
          height: 1.4.h,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            color: colorScheme.onSurface.withOpacity(0.9),
            height: 1.4.h,
          ),
          maxLines: isExpanded ? null : 3,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (content.length > 100) _buildReadMoreButton(colorScheme),
      ],
    );
  }

  Widget _buildReadMoreButton(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Text(
          isExpanded ? 'Show less' : 'Read more',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildVotingRow(Comment comment) {
    return Row(
      children: [
        // Upvote
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
              onTap: () => context.read<UpvoteCommentCubit>().upVoteComment(comment),
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
        // Downvote
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
              onTap: () => context.read<DownvoteCommentCubit>().downVoteComment(comment),
            );
          },
        ),
        SizedBox(width: 20.w),
      ],
    );
  }

  Widget _buildOptionsItem(
      String text,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
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
    final currentUserAvatar = widget.userInfo?.avatar;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        TextEditingController commentController = TextEditingController(text: content);

        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: currentUserAvatar != null && currentUserAvatar.isNotEmpty
                    ? AssetImage(currentUserAvatar)
                    : null,
                radius: 16.r,
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                child: currentUserAvatar == null || currentUserAvatar.isEmpty
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
                final newContent = commentController.text.trim();
                if (newContent.isNotEmpty && widget.edit != null) {
                  setState(() {
                    showOptions = false;
                  });
                  Future.delayed(Duration.zero, () {
                    widget.edit!(widget.comment, newContent);
                  });
                  Navigator.pop(context);
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

  String _getTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
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