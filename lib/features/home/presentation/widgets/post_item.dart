import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../profile/presentation/views/profile_screen.dart';

class PostItem extends StatefulWidget {
  final post;
  final userInfo; 
  final Function? delete; 
  final Function? edit;
  final isUserPost;

  const PostItem({
    super.key,
    required this.post,
    this.userInfo,
    this.delete,
    this.isUserPost,
    this.edit,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isExpanded = false;
  bool isUpVoted = false;
  bool isDownVoted = false;
  bool showOptions = false;

  
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

    final avatar = userInfo != null ? userInfo.avatar : post.avatar;
    final author = userInfo != null ? userInfo.name : post.author;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      List<Author> users = Author.users;
                      final user = users.firstWhere(
                        (user) => user.avatar == post.avatar,
                        orElse: () => users.first,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userInfo: user)),
                      );
                    },
                    child: CircleAvatar(
                      radius: 16.r,
                      backgroundImage: AssetImage(avatar),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: 10.w),
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
                                    fontSize: 14.sp),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text('${post.time}h ago',
                            style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 11.sp)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/community', extra: community),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 7.r,
                            backgroundImage: AssetImage(post.communityImage),
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'c/${post.communityName}',
                            style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.8),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.isUserPost
                      ? IconButton(
                          icon: Icon(Icons.more_horiz,
                              color: colorScheme.onSurface.withOpacity(0.8),
                              size: 18.r),
                          onPressed: () {
                            setState(() {
                              showOptions = !showOptions;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: 32.w,
                            minHeight: 32.w,
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.only(left: 40.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.title,
                        style: textTheme.titleMedium?.copyWith(
                            fontSize: 16.sp, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8.h),
                    Text(
                      post.description,
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          height: 1.4,
                          color: colorScheme.onSurface.withOpacity(0.9)),
                    ),
                    if (post.description.length > 200)
                      GestureDetector(
                        onTap: () => setState(() => isExpanded = !isExpanded),
                        child: Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Text(
                            isExpanded ? 'Show less' : 'Read more',
                            style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp),
                          ),
                        ),
                      ),
                    SizedBox(height: 5.h),
                    post.image != null
                        ? Container(
                            child: Image.file(post.image),
                          )
                        : Container(),
                    if (post.tags != null && post.tags.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: post.tags.map<Widget>((tag) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '#$tag',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        _buildVoteButton(
                          icon: FontAwesomeIcons.arrowUp,
                          isActive: isUpVoted,
                          color: themeExtension?.upVote ?? Colors.green,
                          onTap: () => toggleVote(true),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${post.voteCount}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: isUpVoted
                                ? themeExtension?.upVote
                                : isDownVoted
                                    ? themeExtension?.downVote
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.8),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        _buildVoteButton(
                          icon: FontAwesomeIcons.arrowDown,
                          isActive: isDownVoted,
                          color: themeExtension?.downVote ?? Colors.red,
                          onTap: () => toggleVote(false),
                        ),
                        SizedBox(width: 20.w),
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
        if (showOptions)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Transform.translate(
                offset: const Offset(0, -10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
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
                          _showEditPostDialog(
                              post.id, post.title, post.description);
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

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            icon,
            size: 16.r,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
          if (text.isNotEmpty) ...[
            SizedBox(width: 4.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
          horizontal: 4.w,
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

  void _showEditPostDialog(String id, String title, String description) {
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);
    final currentUser = Author.users[0]; 

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
                radius: 16.r,
              ),
              const SizedBox(width: 10),
              Text(
                'Edit Post',
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
                TextField(
                  controller: titleController,
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
                      showOptions != showOptions;
                      widget.edit!(
                          id, titleController.text, descriptionController.text);
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
