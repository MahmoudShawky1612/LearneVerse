import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../home/models/community_model.dart';
import '../views/profile_screen.dart';

class CommentItem extends StatefulWidget {
  final comment;
  final bool flag;
  final dynamic userInfo;  // Added userInfo parameter

  const CommentItem({
    super.key,
    required this.comment,
    required this.flag,
    this.userInfo,  // Optionally passed userInfo for dynamic avatar and name
  });

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isUpVoted = false;
  bool isDownVoted = false;
  bool isExpanded = false;
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    Community community = Community.communities
        .firstWhere((comm) => comm.image == widget.comment.communityImage);

    final comment = widget.comment;
    final flag = widget.flag;
    final userInfo = widget.userInfo;  // Get userInfo passed to CommentItem

    // Use userInfo if not null, otherwise fallback to comment data
    final String avatar = userInfo != null ? userInfo.avatar : comment.avatar;
    final String name = userInfo != null ? userInfo.name : comment.author;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        gradient: AppColors.containerGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 2, // Slight spread to "get out" without depth
            offset: const Offset(0, 0), // Centered, no directional depth
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.circleGradient,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      List<Author> users = Author.users;
                      final user = users
                          .firstWhere((user) => user.avatar == avatar);  // Use avatar from userInfo or comment
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userInfo: user)),
                      );
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(avatar),
                      backgroundColor: AppColors.backgroundLight,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,  // Use name from userInfo or comment
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        flag
                            ? Row(
                          children: [
                            const SizedBox(width: 4),
                            const FaIcon(
                              FontAwesomeIcons.solidCircle,
                              size: 6,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              comment.repliedTo,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        )
                            : Container(),
                      ],
                    ),
                    Text(
                      '${comment.time}h ago',
                      style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    flag
                        ? GestureDetector(
                      onTap: () {
                        context.push('/community', extra: community);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                              AppColors.primaryDark.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 9,
                              backgroundImage:
                              AssetImage(comment.communityImage),
                              backgroundColor: AppColors.backgroundLight,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'c/${comment.communityName}',
                              style: TextStyle(
                                color: AppColors.textSecondary
                                    .withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : Container(),
                    const SizedBox(width: 6),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            color: AppColors.textSecondary.withOpacity(0.8),
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              showOptions = !showOptions;
                            });
                          },
                        ),
                        if (showOptions)
                          Positioned(
                            right: 30,
                            top: -8,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textSecondary
                                        .withOpacity(0.3),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: AppColors.primaryDark,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: AppColors.secondaryDark,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              comment.comment,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary.withOpacity(0.9),
                height: 1.5,
              ),
              maxLines: isExpanded ? null : 3,
            ),
            if (comment.comment.length > 100)
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    isExpanded ? 'Show less' : 'Read more',
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
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
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: isUpVoted ? 1.1 : 1.0,
                        child: Icon(
                          CupertinoIcons.arrow_up_circle_fill,
                          size: 22,
                          color: isUpVoted
                              ? AppColors.upVote
                              : AppColors.textSecondary.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${comment.voteCount}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: comment.voteCount > 0
                            ? AppColors.upVote
                            : comment.voteCount < 0
                            ? AppColors.downVote
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
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
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: isDownVoted ? 1.1 : 1.0,
                        child: Icon(
                          CupertinoIcons.arrow_down_circle_fill,
                          size: 22,
                          color: isDownVoted
                              ? AppColors.downVote
                              : AppColors.textSecondary.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    isExpanded = !isExpanded;
                  }),
                  child: const Icon(
                    Icons.reply_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
