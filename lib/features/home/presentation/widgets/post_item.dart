import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class PostItem extends StatefulWidget {
  final post;

  const PostItem({Key? key, required this.post}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isExpanded = false;
  bool isUpVoted = false;
  bool isDownVoted = false;
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    Community community = Community.communities.firstWhere((comm) => comm.image == widget.post.communityImage);

    final post = widget.post;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(post.avatar),
                    backgroundColor: AppColors.backgroundLight,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.author,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            context.push('/community', extra: community);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryDark.withOpacity(0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 9,
                                  backgroundImage: AssetImage(post.communityImage),
                                  backgroundColor: AppColors.backgroundLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'c/${post.communityName}',
                                  style: TextStyle(
                                    color: AppColors.textSecondary.withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                    Text(
                      '${post.time}h ago',
                      style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: AppColors.textPrimary.withOpacity(0.8),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      showOptions = !showOptions;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.description,
                  maxLines: isExpanded ? null : 3,
                  overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary.withOpacity(0.9),
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (post.description.length > 200)
                  GestureDetector(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
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
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isUpVoted) {
                            post.voteCount--;
                            isUpVoted = false;
                          } else {
                            post.voteCount++;
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
                          size: 24,
                          color: isUpVoted
                              ? AppColors.upVote
                              : AppColors.textSecondary.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${post.voteCount}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: post.voteCount > 0
                            ? AppColors.upVote
                            : post.voteCount < 0
                            ? AppColors.downVote
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isDownVoted) {
                            post.voteCount++;
                            isDownVoted = false;
                          } else {
                            post.voteCount--;
                            isDownVoted = true;
                            isUpVoted = false;
                          }
                        });
                      },
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: isDownVoted ? 1.1 : 1.0,
                        child: Icon(
                          CupertinoIcons.arrow_down_circle_fill,
                          size: 24,
                          color: isDownVoted
                              ? AppColors.downVote
                              : AppColors.textSecondary.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    context.push('/comments', extra: post);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withOpacity(0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.comment,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${post.commentCount}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
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
      ),
    );
  }
}
