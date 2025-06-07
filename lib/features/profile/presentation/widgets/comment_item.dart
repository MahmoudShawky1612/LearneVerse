import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../comments/data/models/comment_model.dart';


class CommentItem extends StatefulWidget {
  final Comment comment;
  final dynamic userInfo;
  final Function? delete;
  final Function? edit;
  final  flag;

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
  int voteCount = 0;

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
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
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 14.r,
                      backgroundImage: comment.author.userProfile?.profilePictureURL != null
                          ? NetworkImage(comment.author.userProfile!.profilePictureURL!)
                          : null,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                comment.author.username,
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
                 widget.flag == false ? SizedBox.shrink() : IconButton(
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
                  if (showOptions)
                    Positioned(
                      right: 30.w,
                      top: 30.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.onSurface.withOpacity(0.2),
                              blurRadius: 4.r,
                              offset: const Offset(0, 2),
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
                                  () {
                                _showEditCommentDialog(comment.content ?? '');
                              },
                            ),
                            Divider(
                                height: 8.h,
                                color: colorScheme.onSurface.withOpacity(0.1)),
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
                                    widget.delete!(comment.id);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(left: 36.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.content ?? '',
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: colorScheme.onSurface.withOpacity(0.9),
                        height: 1.4.h,
                      ),
                      maxLines: isExpanded ? null : 3,
                    ),
                    if ((comment.content?.length ?? 0) > 100)
                      GestureDetector(
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
                      ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        _buildVoteButton(
                          icon: FontAwesomeIcons.arrowUp,
                          isActive: isUpVoted,
                          color: Colors.green,
                          onTap: () {
                            setState(() {
                              if (isUpVoted) {
                                voteCount--;
                                isUpVoted = false;
                              } else {
                                voteCount++;
                                isUpVoted = true;
                                isDownVoted = false;
                              }
                            });
                          },
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '$voteCount',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: isUpVoted
                                ? Colors.green
                                : isDownVoted
                                ? Colors.red
                                : theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _buildVoteButton(
                          icon: FontAwesomeIcons.arrowDown,
                          isActive: isDownVoted,
                          color: Colors.red,
                          onTap: () {
                            setState(() {
                              if (isDownVoted) {
                                voteCount++;
                                isDownVoted = false;
                              } else {
                                voteCount--;
                                isUpVoted = false;
                                isDownVoted = true;
                              }
                            });
                          },
                        ),
                        SizedBox(width: 16.w),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVoteButton({
    required IconData icon,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: FaIcon(
        icon,
        size: 16.r,
        color: isActive
            ? color
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
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
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 4.h,
          horizontal: 2.w,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.r,
              color: color,
            ),
            SizedBox(width: 6.w),
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
    final currentUser = widget.userInfo?.avatar;

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
                backgroundImage: currentUser != null ? AssetImage(currentUser) : null,
                radius: 16.r,
              ),
              const SizedBox(width: 10),
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
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextButton(
                onPressed: () {
                  if (widget.edit != null) {
                    setState(() {
                      showOptions = !showOptions;
                      Future.delayed(Duration.zero, () {
                        widget.edit!(widget.comment, commentController.text);
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Comment',
                  style: TextStyle(color: Colors.white),
                ),
              ),
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
    } else {
      return '${difference.inMinutes}m';
    }
  }
}