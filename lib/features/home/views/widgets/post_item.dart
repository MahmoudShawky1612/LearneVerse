import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/community/logic/cubit/forum_cubit.dart';
import 'package:flutterwidgets/features/home/data/models/post_model.dart';
import 'package:flutterwidgets/features/home/views/widgets/vote_button.dart';
import 'package:flutterwidgets/features/home/service/feed_post_service.dart';
import 'package:flutterwidgets/features/home/logic/cubit/upvote_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/downvote_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/upvote_states.dart';
import 'package:flutterwidgets/features/home/logic/cubit/downvote_states.dart';
import 'package:flutterwidgets/utils/snackber_util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/jwt_helper.dart';
import '../../../../utils/token_storage.dart';
import '../../../../utils/url_helper.dart';
import '../../../community/logic/cubit/forum.states.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final void Function(Post post)? onDelete;
  final void Function(Post post, Map<String, dynamic> updatedData)? onEdit;
  final bool useForumCubit;

  const PostItem({
    super.key,
    required this.post,
    this.onDelete,
    this.onEdit,
    this.useForumCubit = true,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> with TickerProviderStateMixin {
  bool isExpanded = false;
  bool isMenuVisible = false;
  late int voteCounter;
  late int commentCounter;
  bool isAuthor = false;
  late Post currentPost;

  @override
  void initState() {
    super.initState();
    currentPost = widget.post;
    voteCounter = currentPost.voteCounter;
    commentCounter = currentPost.commentCount;
    _checkIfAuthor();
  }

  Future<void> _checkIfAuthor() async {
    final userId = await getUserId();
    if (mounted) {
      setState(() {
        isAuthor = userId == currentPost.author.id;
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

  Widget _buildImageWidget(String imageUrl) {
    final transformedUrl = UrlHelper.transformUrl(imageUrl);
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: CachedNetworkImage(
          imageUrl: transformedUrl,
          fit: BoxFit.cover,
          errorWidget: (context, error, stackTrace) {
            return Container(
              height: 200.h,
              width: double.infinity,
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.grey[600], size: 32.sp),
                  SizedBox(height: 8.h),
                  Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'URL: $transformedUrl',
                      style:
                          TextStyle(color: Colors.grey[500], fontSize: 10.sp),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
          placeholder: (context, url) => SizedBox(
            height: 200.h,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CupertinoActivityIndicator(),
                  SizedBox(height: 8.h),
                  Text('Loading image...', style: TextStyle(fontSize: 12.sp)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditPostDialog() async {
    final titleController = TextEditingController(text: currentPost.title);
    final contentController =
        TextEditingController(text: currentPost.content ?? '');
    List<String> editableAttachments = List.from(currentPost.attachments);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            bool listsEqual(List<String> list1, List<String> list2) {
              if (list1.length != list2.length) return false;
              for (int i = 0; i < list1.length; i++) {
                if (list1[i] != list2[i]) return false;
              }
              return true;
            }

            bool hasChanges() {
              final titleChanged =
                  titleController.text.trim() != currentPost.title;
              final contentChanged =
                  contentController.text.trim() != (currentPost.content ?? '');
              final attachmentsChanged =
                  !listsEqual(editableAttachments, currentPost.attachments);
              return titleChanged || contentChanged || attachmentsChanged;
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(16.w),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  maxWidth: MediaQuery.of(context).size.width - 32.w,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.3),
                      blurRadius: 20.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withOpacity(0.1),
                            colorScheme.primary.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.edit_rounded,
                              color: colorScheme.primary,
                              size: 24.r,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Edit Your Post',
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Make your post shine ✨',
                                  style: TextStyle(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: Icon(
                              Icons.close_rounded,
                              color: colorScheme.onSurface.withOpacity(0.7),
                              size: 20.r,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  colorScheme.surface.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Author Info
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18.r,
                                  backgroundImage:
                                      currentPost.author.profilePictureURL !=
                                              null
                                          ? CachedNetworkImageProvider(
                                              UrlHelper.transformUrl(currentPost
                                                  .author.profilePictureURL!))
                                          : null,
                                  backgroundColor:
                                      colorScheme.primary.withOpacity(0.1),
                                  child: currentPost.author.profilePictureURL ==
                                          null
                                      ? Icon(
                                          Icons.person,
                                          size: 20.r,
                                          color: colorScheme.primary,
                                        )
                                      : null,
                                ),
                                SizedBox(width: 12.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentPost.author.fullname,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    Text(
                                      'Editing post',
                                      style: TextStyle(
                                        color: colorScheme.onSurface
                                            .withOpacity(0.6),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),
                            // Title Field
                            _buildModernTextField(
                              controller: titleController,
                              label: 'Post Title',
                              hint: 'What\'s on your mind?',
                              icon: Icons.title_rounded,
                              colorScheme: colorScheme,
                              theme: theme,
                            ),
                            SizedBox(height: 16.h),
                            // Content Field
                            _buildModernTextField(
                              controller: contentController,
                              label: 'Post Content',
                              hint: 'Share your thoughts...',
                              icon: Icons.description_rounded,
                              colorScheme: colorScheme,
                              theme: theme,
                              maxLines: 4,
                            ),
                            SizedBox(height: 20.h),
                            // Images Section
                            if (editableAttachments.isNotEmpty) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.image_rounded,
                                    color: colorScheme.primary,
                                    size: 20.r,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Attached Images ({editableAttachments.length})',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      editableAttachments.length == 1 ? 1 : 2,
                                  crossAxisSpacing: 12.w,
                                  mainAxisSpacing: 12.h,
                                  childAspectRatio:
                                      editableAttachments.length == 1
                                          ? 1.5
                                          : 1.0,
                                ),
                                itemCount: editableAttachments.length,
                                itemBuilder: (context, index) {
                                  return _buildEditableImageItem(
                                    editableAttachments[index],
                                    index,
                                    colorScheme,
                                    () {
                                      setDialogState(() {
                                        editableAttachments.removeAt(index);
                                      });
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ],
                        ),
                      ),
                    ),
                    // Action Buttons
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  side: BorderSide(
                                    color: colorScheme.outline.withOpacity(0.3),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                final newTitle = titleController.text.trim();
                                final newContent =
                                    contentController.text.trim();
                                if (newTitle.isEmpty) {
                                  SnackBarUtils.showErrorSnackBar(context,
                                      message: 'Title cannot be empty! 📝');
                                  return;
                                }
                                if (!hasChanges()) {
                                  SnackBarUtils.showInfoSnackBar(context,
                                      message:
                                          'No changes detected! Make some edits first ✏️');
                                  return;
                                }
                                final updatedData = {
                                  'title': newTitle,
                                  'content': newContent,
                                  'attachments': editableAttachments,
                                };
                                if (widget.onEdit != null) {
                                  widget.onEdit!(currentPost, updatedData);
                                }
                                Navigator.pop(dialogContext);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 18.r,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Update Post',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: Text(
            'Delete Post',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this post? This action cannot be undone.',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed == true && widget.onDelete != null) {
      widget.onDelete!(currentPost);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useForumCubit) {
      // --- ForumCubit logic (old behavior) ---
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final textTheme = theme.textTheme;
      return MultiBlocProvider(
        providers: [
          BlocProvider<UpvoteCubit>(
            create: (_) => UpvoteCubit(FeedPostsApiService()),
          ),
          BlocProvider<DownvoteCubit>(
            create: (_) => DownvoteCubit(FeedPostsApiService()),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<ForumCubit, ForumStates>(
              listener: (context, state) {
                if (state is ForumSuccess) {
                  setState(() {
                    currentPost = state.posts.firstWhere(
                      (post) => post.id == currentPost.id,
                      orElse: () => currentPost,
                    );
                  });
                } else if (state is EditPostSuccess) {
                  setState(() {
                    currentPost = state.updatedPost;
                  });
                  SnackBarUtils.showSuccessSnackBar(context,
                      message: 'Post updated successfully 👍');
                  if (widget.onEdit != null) {
                    widget.onEdit!(currentPost, {
                      'title': currentPost.title,
                      'content': currentPost.content,
                      'attachments': currentPost.attachments,
                    });
                  }
                } else if (state is DeletePostSuccess) {
                  SnackBarUtils.showInfoSnackBar(context,
                      message: 'Post deleted successfully 👍');
                  if (widget.onDelete != null) {
                    widget.onDelete!(currentPost);
                  }
                }
              },
            ),
          ],
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    PostProfileAvatar(post: currentPost),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentPost.author.fullname,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${_getTimeAgo(currentPost.createdAt)} ago',
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    isAuthor
                        ? IconButton(
                            icon: Icon(Icons.more_horiz, size: 18.r),
                            onPressed: () =>
                                setState(() => isMenuVisible = !isMenuVisible),
                            padding: EdgeInsets.zero,
                            constraints:
                                BoxConstraints(minWidth: 32.w, minHeight: 32.w),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                SizedBox(height: 12.h),
                // Content
                Padding(
                  padding: EdgeInsets.only(left: 40.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentPost.title,
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        currentPost.content ?? '',
                        maxLines: isExpanded ? null : 3,
                        overflow: isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: textTheme.bodyMedium
                            ?.copyWith(fontSize: 14.sp, height: 1.4),
                      ),
                      if (currentPost.content != null &&
                          currentPost.content!.length > 200)
                        GestureDetector(
                          onTap: () => setState(() => isExpanded = !isExpanded),
                          child: Padding(
                            padding: EdgeInsets.only(top: 6.h),
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
                      if (currentPost.attachments.isNotEmpty)
                        ...currentPost.attachments
                            .map((url) => _buildImageWidget(url)),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          // Upvote
                          BlocConsumer<UpvoteCubit, UpVoteStates>(
                            listener: (context, state) {
                              if (state is UpVoteSuccess) {
                                setState(() {
                                  voteCounter = currentPost.voteCounter;
                                  // upVoteColor = currentPost.voteType == "UPVOTE" ? const Color(0xFF00E676) : Colors.grey;
                                  // downVoteColor = Colors.grey;
                                });
                              }
                            },
                            builder: (context, state) {
                              return EnhancedVoteButton(
                                icon: Icons.arrow_circle_up_rounded,
                                color: Colors.grey,
                                // upVoteColor,
                                isLoading: state is UpVoteLoading,
                                isUpvote: true,
                                onTap: () => context
                                    .read<UpvoteCubit>()
                                    .upVote(currentPost),
                              );
                            },
                          ),
                          SizedBox(width: 4.w),
                          Text('$voteCounter',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp)),
                          SizedBox(width: 10.w),
                          // Downvote
                          BlocConsumer<DownvoteCubit, DownVoteStates>(
                            listener: (context, state) {
                              if (state is DownVoteSuccess) {
                                setState(() {
                                  voteCounter = currentPost.voteCounter;
                                  // downVoteColor = currentPost.voteType == "DOWNVOTE" ? const Color(0xFFFF1744) : Colors.grey;
                                  // upVoteColor = Colors.grey;
                                });
                              }
                            },
                            builder: (context, state) {
                              return EnhancedVoteButton(
                                icon: Icons.arrow_circle_down_rounded,
                                color: Colors.grey,
                                // downVoteColor,
                                isLoading: state is DownVoteLoading,
                                isUpvote: false,
                                onTap: () => context
                                    .read<DownvoteCubit>()
                                    .downVote(currentPost),
                              );
                            },
                          ),
                          SizedBox(width: 20.w),
                          // Comments
                          _buildActionButton(
                            icon: FontAwesomeIcons.comment,
                            text: '$commentCounter',
                            onTap: () =>
                                context.push('/comments', extra: currentPost),
                          ),
                        ],
                      ),
                      // Options Menu
                      if (isAuthor && isMenuVisible)
                        _buildOptionsMenuForum(colorScheme, context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // --- Dumb/callback-only logic (profile tab) ---
      return _buildDumbPostItem(context);
    }
  }

  Widget _buildOptionsMenuForum(ColorScheme colorScheme, BuildContext context) {
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
          BlocBuilder<ForumCubit, ForumStates>(
            builder: (context, state) {
              return _buildOptionsItem(
                'Edit',
                Icons.edit_outlined,
                colorScheme.primary,
                state is ForumLoading
                    ? null
                    : () => _showEditPostDialogForum(context),
                isLoading: state is ForumLoading,
              );
            },
          ),
          Divider(
            height: 8.h,
            color: colorScheme.onSurface.withOpacity(0.1),
          ),
          BlocBuilder<ForumCubit, ForumStates>(
            builder: (context, state) {
              return _buildOptionsItem(
                'Delete',
                Icons.delete_outline,
                colorScheme.error,
                state is ForumLoading
                    ? null
                    : () {
                        setState(() {
                          isMenuVisible = false;
                        });
                        _showDeleteConfirmationDialogForum(context);
                      },
                isLoading: state is ForumLoading,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEditPostDialogForum(BuildContext context) {
    final titleController = TextEditingController(text: currentPost.title);
    final contentController =
        TextEditingController(text: currentPost.content ?? '');
    List<String> editableAttachments = List.from(currentPost.attachments);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            bool listsEqual(List<String> list1, List<String> list2) {
              if (list1.length != list2.length) return false;
              for (int i = 0; i < list1.length; i++) {
                if (list1[i] != list2[i]) return false;
              }
              return true;
            }

            bool hasChanges() {
              final titleChanged =
                  titleController.text.trim() != currentPost.title;
              final contentChanged =
                  contentController.text.trim() != (currentPost.content ?? '');
              final attachmentsChanged =
                  !listsEqual(editableAttachments, currentPost.attachments);
              return titleChanged || contentChanged || attachmentsChanged;
            }

            return BlocProvider.value(
              value: context.read<ForumCubit>(),
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.all(16.w),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                    maxWidth: MediaQuery.of(context).size.width - 32.w,
                  ),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.3),
                        blurRadius: 20.r,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withOpacity(0.1),
                              colorScheme.primary.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                color: colorScheme.primary,
                                size: 24.r,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Edit Your Post',
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Make your post shine ✨',
                                    style: TextStyle(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.7),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              icon: Icon(
                                Icons.close_rounded,
                                color: colorScheme.onSurface.withOpacity(0.7),
                                size: 20.r,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    colorScheme.surface.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Content
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Author Info
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18.r,
                                    backgroundImage: currentPost
                                                .author.profilePictureURL !=
                                            null
                                        ? CachedNetworkImageProvider(
                                            UrlHelper.transformUrl(currentPost
                                                .author.profilePictureURL!))
                                        : null,
                                    backgroundColor:
                                        colorScheme.primary.withOpacity(0.1),
                                    child:
                                        currentPost.author.profilePictureURL ==
                                                null
                                            ? Icon(
                                                Icons.person,
                                                size: 20.r,
                                                color: colorScheme.primary,
                                              )
                                            : null,
                                  ),
                                  SizedBox(width: 12.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentPost.author.fullname,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        'Editing post',
                                        style: TextStyle(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.6),
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              // Title Field
                              _buildModernTextField(
                                controller: titleController,
                                label: 'Post Title',
                                hint: 'What\'s on your mind?',
                                icon: Icons.title_rounded,
                                colorScheme: colorScheme,
                                theme: theme,
                              ),
                              SizedBox(height: 16.h),
                              // Content Field
                              _buildModernTextField(
                                controller: contentController,
                                label: 'Post Content',
                                hint: 'Share your thoughts...',
                                icon: Icons.description_rounded,
                                colorScheme: colorScheme,
                                theme: theme,
                                maxLines: 4,
                              ),
                              SizedBox(height: 20.h),
                              // Images Section
                              if (editableAttachments.isNotEmpty) ...[
                                Row(
                                  children: [
                                    Icon(
                                      Icons.image_rounded,
                                      color: colorScheme.primary,
                                      size: 20.r,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Attached Images (${editableAttachments.length})',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        editableAttachments.length == 1 ? 1 : 2,
                                    crossAxisSpacing: 12.w,
                                    mainAxisSpacing: 12.h,
                                    childAspectRatio:
                                        editableAttachments.length == 1
                                            ? 1.5
                                            : 1.0,
                                  ),
                                  itemCount: editableAttachments.length,
                                  itemBuilder: (context, index) {
                                    return _buildEditableImageItem(
                                      editableAttachments[index],
                                      index,
                                      colorScheme,
                                      () {
                                        setDialogState(() {
                                          editableAttachments.removeAt(index);
                                        });
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ],
                          ),
                        ),
                      ),
                      // Action Buttons
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.3),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    side: BorderSide(
                                      color:
                                          colorScheme.outline.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              flex: 2,
                              child: BlocConsumer<ForumCubit, ForumStates>(
                                listener: (context, state) {
                                  if (state is EditPostSuccess) {
                                    Navigator.pop(dialogContext);
                                    // Use Future.delayed to ensure dialog is closed first
                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      SnackBarUtils.showSuccessSnackBar(context,
                                          message:
                                              'Post updated successfully! 🎉');
                                    });
                                  } else if (state is ForumFailure) {
                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      SnackBarUtils.showErrorSnackBar(context,
                                          message:
                                              'Failed to update post: ${state.message} 😞');
                                    });
                                  }
                                },
                                builder: (context, state) {
                                  return ElevatedButton(
                                    onPressed: state is ForumLoading
                                        ? null
                                        : () {
                                            final newTitle =
                                                titleController.text.trim();
                                            final newContent =
                                                contentController.text.trim();

                                            if (newTitle.isEmpty) {
                                              SnackBarUtils.showErrorSnackBar(
                                                  context,
                                                  message:
                                                      'Title cannot be empty! 📝');
                                              return;
                                            }

                                            if (!hasChanges()) {
                                              SnackBarUtils.showInfoSnackBar(
                                                  context,
                                                  message:
                                                      'No changes detected! Make some edits first ✏️');
                                              return;
                                            }

                                            final updatedData = {
                                              'title': newTitle,
                                              'content': newContent,
                                              'attachments':
                                                  editableAttachments,
                                            };

                                            context.read<ForumCubit>().editPost(
                                                currentPost.id,
                                                updatedData,
                                                currentPost.forumId);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme.primary,
                                      foregroundColor: colorScheme.onPrimary,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: state is ForumLoading
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 16.w,
                                                height: 16.h,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          colorScheme
                                                              .onPrimary),
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                'Updating...',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle_rounded,
                                                size: 18.r,
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                'Update Post',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                  );
                                },
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
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialogForum(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return BlocProvider.value(
          value: context.read<ForumCubit>(),
          child: AlertDialog(
            backgroundColor: theme.cardColor,
            title: Text(
              'Delete Post',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to delete this post? This action cannot be undone.',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14.sp,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
              BlocBuilder<ForumCubit, ForumStates>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is ForumLoading
                        ? null
                        : () {
                            context.read<ForumCubit>().deletePost(
                                currentPost.id, currentPost.forumId);
                            Navigator.pop(dialogContext);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: state is ForumLoading
                        ? SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.onError),
                            ),
                          )
                        : const Text('Delete'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ColorScheme colorScheme,
    required ThemeData theme,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
              size: 18.r,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.05),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines ?? 1,
            style: TextStyle(
              fontSize: 16.sp,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 16.sp,
              ),
              filled: true,
              fillColor: colorScheme.surface.withOpacity(0.7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2.w,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableImageItem(
    String imageUrl,
    int index,
    ColorScheme colorScheme,
    VoidCallback onRemove,
  ) {
    final transformedUrl = UrlHelper.transformUrl(imageUrl);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: transformedUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  color: colorScheme.errorContainer,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_rounded,
                        color: colorScheme.onErrorContainer,
                        size: 32.r,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Failed to load',
                        style: TextStyle(
                          color: colorScheme.onErrorContainer,
                          fontSize: 12.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                placeholder: (context, url) => Container(
                  color: colorScheme.surface,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Remove Button
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.2),
                      blurRadius: 4.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: colorScheme.onErrorContainer,
                  size: 16.r,
                ),
              ),
            ),
          ),
          // Image Index
          Positioned(
            bottom: 8.h,
            left: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
    VoidCallback? onTap, {
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: isLoading
          ? null
          : () {
              setState(() {
                isMenuVisible = false;
              });
              onTap?.call();
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
            if (isLoading)
              SizedBox(
                width: 16.r,
                height: 16.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            else
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

  Widget _buildDumbPostItem(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              PostProfileAvatar(post: currentPost),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentPost.author.fullname,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${_getTimeAgo(currentPost.createdAt)} ago',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              isAuthor
                  ? IconButton(
                      icon: Icon(Icons.more_horiz, size: 18.r),
                      onPressed: () =>
                          setState(() => isMenuVisible = !isMenuVisible),
                      padding: EdgeInsets.zero,
                      constraints:
                          BoxConstraints(minWidth: 32.w, minHeight: 32.w),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 12.h),
          // Content
          Padding(
            padding: EdgeInsets.only(left: 40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentPost.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  currentPost.content ?? '',
                  maxLines: isExpanded ? null : 3,
                  overflow:
                      isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: textTheme.bodyMedium
                      ?.copyWith(fontSize: 14.sp, height: 1.4),
                ),
                if (currentPost.content != null &&
                    currentPost.content!.length > 200)
                  GestureDetector(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: Padding(
                      padding: EdgeInsets.only(top: 6.h),
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
                if (currentPost.attachments.isNotEmpty)
                  ...currentPost.attachments
                      .map((url) => _buildImageWidget(url)),
                SizedBox(height: 12.h),
                // Comments
                _buildActionButton(
                  icon: FontAwesomeIcons.comment,
                  text: '$commentCounter',
                  onTap: () => context.push('/comments', extra: currentPost),
                ),
                // Options Menu
                if (isAuthor && isMenuVisible)
                  _buildOptionsMenuDumb(colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsMenuDumb(ColorScheme colorScheme) {
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
            () => _showEditPostDialog(),
          ),
          Divider(
            height: 8.h,
            color: colorScheme.onSurface.withOpacity(0.1),
          ),
          _buildOptionsItem(
            'Delete',
            Icons.delete_outline,
            colorScheme.error,
            () => _showDeleteConfirmationDialog(),
          ),
        ],
      ),
    );
  }
}

class PostProfileAvatar extends StatelessWidget {
  final Post post;

  const PostProfileAvatar({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/profile', extra: post.author.id),
      child: CircleAvatar(
        radius: 14.r,
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: _getAvatarContent(post, context),
      ),
    );
  }

  Widget _getAvatarContent(Post post, BuildContext context) {
    final profilePictureURL = post.author.profilePictureURL;

    if (profilePictureURL != null && profilePictureURL.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: UrlHelper.transformUrl(profilePictureURL),
          width: 28.r,
          height: 28.r,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => _getDefaultAvatar(context),
          placeholder: (context, url) => SizedBox(
            width: 28.r,
            height: 28.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      );
    } else {
      return _getDefaultAvatar(context);
    }
  }

  Widget _getDefaultAvatar(BuildContext context) {
    return Icon(
      Icons.person,
      size: 16.r,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
