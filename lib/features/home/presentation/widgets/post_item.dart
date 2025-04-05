import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../profile/presentation/views/profile_screen.dart';

class PostItem extends StatefulWidget {
  final post;
  final userInfo; // Add userInfo as a parameter to the widget

  const PostItem({Key? key, required this.post, this.userInfo}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isExpanded = false;
  bool isUpVoted = false;
  bool isDownVoted = false;
  bool showOptions = false;

  // Function to toggle the vote
  void toggleVote(bool isUpVote) {
    setState(() {
      if (isUpVote) {
        if (isUpVoted) {
          widget.post.voteCount--;
          isUpVoted = false;
        } else {
          widget.post.voteCount++;
          isUpVoted = true;
          isDownVoted = false;
        }
      } else {
        if (isDownVoted) {
          widget.post.voteCount++;
          isDownVoted = false;
        } else {
          widget.post.voteCount--;
          isDownVoted = true;
          isUpVoted = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Community community = Community.communities.firstWhere((comm) => comm.image == widget.post.communityImage);
    final post = widget.post;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    // Check if userInfo is provided and use that instead of post fields
    final avatar = widget.userInfo != null ? widget.userInfo.avatar : post.avatar;
    final author = widget.userInfo != null ? widget.userInfo.name : post.author;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.2),
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
            // Avatar and author section
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    List<Author> users = Author.users;
                    final user = users.firstWhere((user) => user.avatar == post.avatar);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen(userInfo: user)),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(avatar),
                    backgroundColor: theme.scaffoldBackgroundColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              author, 
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700, 
                                fontSize: 15
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: GestureDetector(
                              onTap: () => context.push('/community', extra: community),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(color: colorScheme.primary.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 2))],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 6,
                                      backgroundImage: AssetImage(post.communityImage),
                                      backgroundColor: theme.scaffoldBackgroundColor,
                                    ),
                                    const SizedBox(width: 2),
                                    Flexible(
                                      child: Text(
                                        'c/${post.communityName}', 
                                        style: TextStyle(
                                          color: colorScheme.onSurface.withOpacity(0.9), 
                                          fontSize: 9, 
                                          fontWeight: FontWeight.w500
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text('${post.time}h ago', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.8), fontSize: 11)),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: colorScheme.onSurface.withOpacity(0.8), size: 20),
                  onPressed: () {
                    setState(() {
                      showOptions = !showOptions;
                    });
                  },
                ),
              ],
            ),
            // Post title and description
            const SizedBox(height: 12),
            Text(post.title, style: textTheme.titleMedium?.copyWith(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              post.description,
              maxLines: isExpanded ? null : 3,
              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(fontSize: 13, height: 1.5, fontWeight: FontWeight.w400, color: colorScheme.onSurface.withOpacity(0.9)),
            ),
            if (post.description.length > 200)
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    isExpanded ? 'Show less' : 'Read more',
                    style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ),
            
            // Post tags
            if (post.tags != null && post.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: post.tags.map<Widget>((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#$tag',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
                
            // Vote and comment buttons
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => toggleVote(true),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 150),
                          scale: isUpVoted ? 1.1 : 1.0,
                          child: Icon(
                            CupertinoIcons.arrow_up_circle_fill,
                            size: 22,
                            color: isUpVoted ? themeExtension?.upVote : colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.voteCount}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: post.voteCount > 0 ? themeExtension?.upVote : post.voteCount < 0 ? themeExtension?.downVote : colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => toggleVote(false),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 150),
                          scale: isDownVoted ? 1.1 : 1.0,
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            size: 22,
                            color: isDownVoted ? themeExtension?.downVote : colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/comments', extra: post),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: colorScheme.primary.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(FontAwesomeIcons.comment, size: 14, color: colorScheme.onSurface),
                        const SizedBox(width: 5),
                        Text('${post.commentCount}', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w600, fontSize: 12)),
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
