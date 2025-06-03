import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../home/models/community_model.dart';
import '../views/profile_screen.dart';

class CommentItem extends StatefulWidget {
  final comment;
  final bool flag;
  final dynamic userInfo;
  final Function? delete;
  final Function? edit;

  const CommentItem({
    super.key,
    required this.comment,
    required this.flag,
    this.userInfo,
    this.delete,
    this.edit,
  });

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isUpVoted = false;
  bool isDownVoted = false;
  bool isExpanded = false;
  bool showOptions = false;
  TextEditingController commentEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Community community = Community.communities
        .firstWhere((comm) => comm.image == widget.comment.communityImage);

    final comment = widget.comment;
    final flag = widget.flag;
    final userInfo = widget.userInfo;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    final String avatar = userInfo != null ? userInfo.avatar : comment.avatar;
    final String name = userInfo != null ? userInfo.name : comment.author;
    TextEditingController commentController = TextEditingController();
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
                    onTap: () {
                      List<Author> users = Author.users;
                      final user =
                          users.firstWhere((user) => user.avatar == avatar);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userInfo: user)),
                      );
                    },
                    child: CircleAvatar(
                      radius: 14.r,
                      backgroundImage: AssetImage(avatar),
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
                                name,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (flag)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 4.w),
                                  FaIcon(
                                    FontAwesomeIcons.solidCircle,
                                    size: 6.r,
                                    color: colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                  SizedBox(width: 4.w),
                                  Flexible(
                                    child: Text(
                                      comment.repliedTo,
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.sp,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${comment.time}h ago',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (flag)
                    GestureDetector(
                      onTap: () {
                        context.push('/community', extra: community);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 7.r,
                              backgroundImage:
                                  AssetImage(comment.communityImage),
                              backgroundColor: Colors.transparent,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'c/${comment.communityName}',
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.8),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  flag
                      ? IconButton(
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
                            minWidth: 30.w,
                            minHeight: 30.w,
                          ),
                        )
                      : Container(),
                  if (showOptions)
                    Positioned(
                      right: 30.w,
                      top: 30.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 6.h,
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
                                _showEditCommentDialog(comment.comment);
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
                      comment.comment ?? comment.comment ?? "",
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: colorScheme.onSurface.withOpacity(0.9),
                        height: 1.4.h,
                      ),
                      maxLines: isExpanded ? null : 3,
                    ),
                    if ((comment.comment?.length ?? 0) > 100 ||
                        (comment.comment?.length ?? 0) > 100)
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
                          color: themeExtension?.upVote ?? Colors.green,
                          onTap: () {
                            setState(() {
                              if (isUpVoted) {
                                comment.voteCount--;
                                isUpVoted = false;
                              } else {
                                comment.voteCount++;
                                isUpVoted = true;
                                isDownVoted = false;
                              }
                            });
                          },
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${comment.voteCount}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: isUpVoted
                                ? themeExtension?.upVote
                                : isDownVoted
                                    ? themeExtension?.downVote
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.8),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _buildVoteButton(
                          icon: FontAwesomeIcons.arrowDown,
                          isActive: isDownVoted,
                          color: themeExtension?.downVote ?? Colors.red,
                          onTap: () {
                            setState(() {
                              if (isDownVoted) {
                                comment.voteCount++;
                                isDownVoted = false;
                              } else {
                                comment.voteCount--;
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

  void _showEditCommentDialog(String comment) {
    final currentUser = widget.userInfo.avatar;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final themeExtension = theme.extension<AppThemeExtension>();
        TextEditingController commentController =
            TextEditingController(text: comment);
        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(currentUser),
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
                gradient: themeExtension?.buttonGradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextButton(
                onPressed: () {
                  if (widget.edit != null) {
                    setState(() {
                      showOptions = !showOptions;
                      Future.delayed(Duration.zero, () {
                        widget.edit!(widget.comment.id, commentController.text);
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
}
