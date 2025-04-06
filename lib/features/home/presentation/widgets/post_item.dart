import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/core/utils/responsive_utils.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../profile/presentation/views/profile_screen.dart';

class PostItem extends StatefulWidget {
  final post;
  final userInfo; // Add userInfo as a parameter to the widget
  final Function? delete; // Add delete callback
  final Function? edit;
  final isUserPost;

  const PostItem({
    Key? key,
    required this.post,
    this.userInfo,
    this.delete,
    this.isUserPost, this.edit,
  }) : super(key: key);

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
    Community community = Community.communities
        .firstWhere((comm) => comm.image == widget.post.communityImage);
    final post = widget.post;
    final userInfo = widget.userInfo;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    final isMobileDevice = context.isMobile;

    // Always use the post's original author information
    final avatar = userInfo != null ? userInfo.avatar : post.avatar;
    final author = userInfo != null ? userInfo.name : post.author;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: context.h(10), horizontal: isMobileDevice ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar and author section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      List<Author> users = Author.users;
                      // Find the author by their exact avatar to ensure correct profile navigation
                      final user = users.firstWhere(
                        (user) => user.avatar == post.avatar,
                        orElse: () =>
                            users.first, // Fallback in case avatar not found
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userInfo: user)),
                      );
                    },
                    child: CircleAvatar(
                      radius: isMobileDevice ? 16 : 18,
                      backgroundImage: AssetImage(avatar),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: context.w(10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                author,
                                style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: isMobileDevice ? 14 : 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(2)),
                        Text('${post.time}h ago',
                            style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.7),
                                fontSize: isMobileDevice ? 11 : 12)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/community', extra: community),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.w(8), vertical: context.h(3)),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: isMobileDevice ? 7 : 8,
                            backgroundImage: AssetImage(post.communityImage),
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(width: context.w(4)),
                          Text(
                            'c/${post.communityName}',
                            style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.8),
                                fontSize: isMobileDevice ? 11 : 12,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.isUserPost ?IconButton(
                    icon: Icon(Icons.more_horiz,
                        color: colorScheme.onSurface.withOpacity(0.8),
                        size: isMobileDevice ? 18 : 20),
                    onPressed: () {
                      setState(() {
                        showOptions = !showOptions;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: isMobileDevice ? 32 : 36,
                      minHeight: isMobileDevice ? 32 : 36,
                    ),
                  ) : Container(),
                ],
              ),

              SizedBox(height: context.h(12)),
              Padding(
                padding:
                    EdgeInsets.only(left: context.w(isMobileDevice ? 40 : 46)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.title,
                        style: textTheme.titleMedium?.copyWith(
                            fontSize: isMobileDevice ? 16 : 17,
                            fontWeight: FontWeight.w700)),
                    SizedBox(height: context.h(8)),
                    Text(
                      post.description,
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                          fontSize: isMobileDevice ? 14 : 15,
                          height: 1.4,
                          color: colorScheme.onSurface.withOpacity(0.9)),
                    ),
                    if (post.description.length > 200)
                      GestureDetector(
                        onTap: () => setState(() => isExpanded = !isExpanded),
                        child: Padding(
                          padding: EdgeInsets.only(top: context.h(6)),
                          child: Text(
                            isExpanded ? 'Show less' : 'Read more',
                            style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: isMobileDevice ? 12 : 13),
                          ),
                        ),
                      ),

                    // Post tags
                    if (post.tags != null && post.tags.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: context.h(12)),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: post.tags.map<Widget>((tag) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: context.w(8),
                                  vertical: context.h(4)),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '#$tag',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: isMobileDevice ? 12 : 13,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    // Vote and comment buttons
                    SizedBox(height: context.h(12)),
                    Row(
                      children: [
                        _buildVoteButton(
                          icon: FontAwesomeIcons.arrowUp,
                          isActive: isUpVoted,
                          color: themeExtension?.upVote ?? Colors.green,
                          onTap: () => toggleVote(true),
                        ),
                        SizedBox(width: context.w(4)),
                        Text(
                          '${post.voteCount}',
                          style: TextStyle(
                            fontSize: isMobileDevice ? 13 : 14,
                            fontWeight: FontWeight.w500,
                            color: isUpVoted
                                ? themeExtension?.upVote
                                : isDownVoted
                                    ? themeExtension?.downVote
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.8),
                          ),
                        ),
                        SizedBox(width: context.w(10)),
                        _buildVoteButton(
                          icon: FontAwesomeIcons.arrowDown,
                          isActive: isDownVoted,
                          color: themeExtension?.downVote ?? Colors.red,
                          onTap: () => toggleVote(false),
                        ),
                        SizedBox(width: context.w(20)),
                        _buildActionButton(
                          icon: FontAwesomeIcons.comment,
                          text: '${post.commentCount}',
                          onTap: () {
                            context.push('/comments', extra: post);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Floating options menu that appears when "more" is clicked
        if (showOptions)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: context.w(12)),
              child: Transform.translate(
                offset: Offset(0, -10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(10),
                    vertical: context.h(8),
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
                          _showEditPostDialog(post.id,post.title, post.description);
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
                            widget.delete!(post.id);
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
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
        size: isMobileDevice ? 16 : 18,
        color: isActive
            ? color
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isMobileDevice = context.isMobile;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            icon,
            size: isMobileDevice ? 16 : 18,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
          if (text.isNotEmpty) ...[
            SizedBox(width: context.w(4)),
            Text(
              text,
              style: TextStyle(
                fontSize: isMobileDevice ? 13 : 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
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
    final isMobileDevice = context.isMobile;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.h(6),
          horizontal: context.w(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isMobileDevice ? 16 : 18,
              color: color,
            ),
            SizedBox(width: context.w(8)),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: isMobileDevice ? 13 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPostDialog(String id, String title, String description) {
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);
    final currentUser = Author.users[0]; // Use the first user as current user

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final themeExtension = theme.extension<AppThemeExtension>();

        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(currentUser.avatar),
                radius: 16,
              ),
              const SizedBox(width: 10),
              Text(
                'Edit Post',
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
                TextField(
                  controller: titleController,
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
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  style: TextStyle(color: colorScheme.onSurface),
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Description',
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
                 if(widget.edit != null ){
                  setState(() {
                    showOptions != showOptions;
                    widget.edit!(id, titleController.text, descriptionController.text);
                  });
                 }
                 Navigator.pop(context);
                },
                child: const Text(
                  'Post',
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
