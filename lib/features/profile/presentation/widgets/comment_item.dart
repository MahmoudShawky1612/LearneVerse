import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/core/utils/responsive_utils.dart';
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
    final bool isMobileDevice = context.isMobile;

    final String avatar = userInfo != null ? userInfo.avatar : comment.avatar;
    final String name = userInfo != null ? userInfo.name : comment.author;
    TextEditingController commentController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: context.h(8), horizontal: isMobileDevice ? 8 : 12),
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
                      radius: isMobileDevice ? 12 : 14,
                      backgroundImage: AssetImage(avatar),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: context.w(8)),
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
                                  fontSize: isMobileDevice ? 12 : 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (flag)
                              Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                  SizedBox(width: context.w(4)),
                                    FaIcon(
                                      FontAwesomeIcons.solidCircle,
                                    size: isMobileDevice ? 4 : 6,
                                    color:
                                        colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                  SizedBox(width: context.w(4)),
                                    Flexible(
                                      child: Text(
                                        comment.repliedTo,
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        fontSize: isMobileDevice ? 12 : 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                              ),
                        ],
                      ),
                        SizedBox(height: context.h(2)),
                      Text(
                        '${comment.time}h ago',
                        style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontSize: isMobileDevice ? 10 : 11,
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
                            horizontal: context.w(6), vertical: context.h(2)),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: isMobileDevice ? 6 : 7,
                              backgroundImage:
                              AssetImage(comment.communityImage),
                              backgroundColor: Colors.transparent,
                            ),
                            SizedBox(width: context.w(2)),
                            Text(
                                'c/${comment.communityName}',
                                style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.8),
                                fontSize: isMobileDevice ? 10 : 12,
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
                            size: isMobileDevice ? 16 : 18,
                          ),
                          onPressed: () {
                            setState(() {
                              showOptions = !showOptions;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: isMobileDevice ? 28 : 30,
                            minHeight: isMobileDevice ? 28 : 30,
                          ),
                        )
                      : Container(),
                        if (showOptions)
                          Positioned(
                            right: 30,
                      top: 30,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(8),
                          vertical: context.h(6),
                        ),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                          borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                              color: colorScheme.onSurface.withOpacity(0.2),
                                    blurRadius: 4,
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
                                height: 8,
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
              SizedBox(height: context.h(8)),
              Padding(
                padding:
                    EdgeInsets.only(left: context.w(isMobileDevice ? 30 : 36)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            Text(
                      comment.comment ?? comment.comment ?? "",
              style: textTheme.bodyMedium?.copyWith(
                        fontSize: isMobileDevice ? 13 : 14,
                color: colorScheme.onSurface.withOpacity(0.9),
                height: 1.4,
              ),
              maxLines: isExpanded ? null : 3,
            ),
                    if ((comment.comment?.length ?? 0) > 100 ||
                        (comment.comment?.length ?? 0) > 100)
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Padding(
                          padding: EdgeInsets.only(top: context.h(4)),
                  child: Text(
                    isExpanded ? 'Show less' : 'Read more',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                              fontSize: isMobileDevice ? 11 : 12,
                    ),
                  ),
                ),
              ),
                    SizedBox(height: context.h(8)),
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
                        SizedBox(width: context.w(8)),
                    Text(
                      '${comment.voteCount}',
                      style: TextStyle(
                            fontSize: isMobileDevice ? 12 : 14,
                            fontWeight: FontWeight.w500,
                            color: isUpVoted
                            ? themeExtension?.upVote
                                : isDownVoted
                            ? themeExtension?.downVote
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.8),
                          ),
                        ),
                        SizedBox(width: context.w(8)),
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
                        SizedBox(width: context.w(16)),
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
    final isMobileDevice = context.isMobile;

    return GestureDetector(
      onTap: onTap,
      child: FaIcon(
        icon,
        size: isMobileDevice ? 14 : 16,
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
    final isMobileDevice = context.isMobile;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.h(4),
          horizontal: context.w(2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isMobileDevice ? 14 : 16,
              color: color,
            ),
            SizedBox(width: context.w(6)),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: isMobileDevice ? 12 : 13,
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
                radius: 16,
              ),
              const SizedBox(width: 10),
              Text(
                'Edit Comment',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
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
                      borderRadius: BorderRadius.circular(12),
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
                borderRadius: BorderRadius.circular(12),
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
