import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/home/data/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/vote_button.dart';
import 'package:flutterwidgets/features/home/service/feed_post_service.dart';
import 'package:flutterwidgets/features/home/service/edit_delete_post_service.dart';
import 'package:flutterwidgets/features/home/logic/cubit/upvote_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/downvote_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/edit_post_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/delete_post_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/upvote_states.dart';
import 'package:flutterwidgets/features/home/logic/cubit/downvote_states.dart';
import 'package:flutterwidgets/features/home/logic/cubit/edit_post_states.dart';
import 'package:flutterwidgets/features/home/logic/cubit/delete_post_states.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/jwt_helper.dart';
import '../../../../utils/token_storage.dart';
import '../../../../utils/url_helper.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final VoidCallback? onPostDeleted;
  final Function(Post)? onPostUpdated;

  const PostItem({
    super.key,
    required this.post,
    this.onPostDeleted,
    this.onPostUpdated,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> with TickerProviderStateMixin {
  bool isExpanded = false;
  bool isMenuVisible = false;
  late Color upVoteColor;
  late Color downVoteColor;
  late int voteCounter;
  late int commentCounter;
  bool isAuthor = false;
  late Post currentPost;

  @override
  void initState() {
    super.initState();
    currentPost = widget.post;
    voteCounter = currentPost.voteCounter;
    upVoteColor = currentPost.voteType == "UPVOTE" ? const Color(0xFF00E676) : Colors.grey;
    downVoteColor = currentPost.voteType == "DOWNVOTE" ? const Color(0xFFFF1744) : Colors.grey;
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
          Text(text, style: TextStyle(color: Colors.grey[700], fontSize: 13.sp)),
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
        child: Image.network(
          transformedUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
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
                      style: TextStyle(color: Colors.grey[500], fontSize: 10.sp),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200.h,
              width: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                    SizedBox(height: 8.h),
                    Text('Loading image...', style: TextStyle(fontSize: 12.sp)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        BlocProvider<EditPostCubit>(
          create: (_) => EditPostCubit(EditDeletePostApiService()),
        ),
        BlocProvider<DeletePostCubit>(
          create: (_) => DeletePostCubit(EditDeletePostApiService()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<EditPostCubit, EditPostState>(
            listener: (context, state) {
              if (state is EditPostSuccess) {
                setState(() {
                  currentPost = state.updatedPost;
                });
                widget.onPostUpdated?.call(state.updatedPost);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Post updated successfully'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (state is EditPostFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update post: ${state.error}'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
          BlocListener<DeletePostCubit, DeletePostState>(
            listener: (context, state) {
              if (state is DeletePostSuccess) {
                widget.onPostDeleted?.call();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Post deleted successfully'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (state is DeletePostFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete post: ${state.error}'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
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
                    onPressed: () => setState(() => isMenuVisible = !isMenuVisible),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.w),
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
                      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(fontSize: 14.sp, height: 1.4),
                    ),
                    if (currentPost.content != null && currentPost.content!.length > 200)
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
                      ...currentPost.attachments.map((url) => _buildImageWidget(url)),
                    SizedBox(height: 12.h),

                    Row(
                      children: [
                        // Upvote
                        BlocConsumer<UpvoteCubit, UpVoteStates>(
                          listener: (context, state) {
                            if (state is UpVoteSuccess) {
                              setState(() {
                                voteCounter = currentPost.voteCounter;
                                upVoteColor = currentPost.voteType == "UPVOTE" ? const Color(0xFF00E676) : Colors.grey;
                                downVoteColor = Colors.grey;
                              });
                            }
                          },
                          builder: (context, state) {
                            return EnhancedVoteButton(
                              icon: Icons.arrow_circle_up_rounded,
                              color: upVoteColor,
                              isLoading: state is UpVoteLoading,
                              isUpvote: true,
                              onTap: () => context.read<UpvoteCubit>().upVote(currentPost),
                            );
                          },
                        ),
                        SizedBox(width: 4.w),
                        Text('$voteCounter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                        SizedBox(width: 10.w),

                        // Downvote
                        BlocConsumer<DownvoteCubit, DownVoteStates>(
                          listener: (context, state) {
                            if (state is DownVoteSuccess) {
                              setState(() {
                                voteCounter = currentPost.voteCounter;
                                downVoteColor = currentPost.voteType == "DOWNVOTE" ? const Color(0xFFFF1744) : Colors.grey;
                                upVoteColor = Colors.grey;
                              });
                            }
                          },
                          builder: (context, state) {
                            return EnhancedVoteButton(
                              icon: Icons.arrow_circle_down_rounded,
                              color: downVoteColor,
                              isLoading: state is DownVoteLoading,
                              isUpvote: false,
                              onTap: () => context.read<DownvoteCubit>().downVote(currentPost),
                            );
                          },
                        ),
                        SizedBox(width: 20.w),

                        // Comments
                        _buildActionButton(
                          icon: FontAwesomeIcons.comment,
                          text: '$commentCounter',
                          onTap: () => context.push('/comments', extra: currentPost),
                        ),
                      ],
                    ),

                    // Options Menu
                    if (isAuthor && isMenuVisible) _buildOptionsMenu(colorScheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsMenu(ColorScheme colorScheme) {
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
          BlocBuilder<EditPostCubit, EditPostState>(
            builder: (context, state) {
              return _buildOptionsItem(
                'Edit',
                Icons.edit_outlined,
                colorScheme.primary,
                state is EditPostLoading ? null : () => _showEditPostDialog(),
                isLoading: state is EditPostLoading,
              );
            },
          ),
          Divider(
            height: 8.h,
            color: colorScheme.onSurface.withOpacity(0.1),
          ),
          BlocBuilder<DeletePostCubit, DeletePostState>(
            builder: (context, state) {
              return _buildOptionsItem(
                'Delete',
                Icons.delete_outline,
                colorScheme.error,
                state is DeletePostLoading ? null : () {
                  setState(() {
                    isMenuVisible = false;
                  });
                  _showDeleteConfirmationDialog();
                },
                isLoading: state is DeletePostLoading,
              );
            },
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
      onTap: isLoading ? null : () {
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

  void _showEditPostDialog() {
    final titleController = TextEditingController(text: currentPost.title);
    final contentController = TextEditingController(text: currentPost.content ?? '');

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return BlocProvider.value(
          value: context.read<EditPostCubit>(),
          child: AlertDialog(
            backgroundColor: theme.cardColor,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundImage: currentPost.author.profilePictureURL != null
                      ? NetworkImage(UrlHelper.transformUrl(currentPost.author.profilePictureURL!))
                      : null,
                  backgroundColor: Colors.grey[300],
                  child: currentPost.author.profilePictureURL == null
                      ? Icon(
                    Icons.person,
                    size: 18.r,
                    color: Colors.grey,
                  )
                      : null,
                ),
                SizedBox(width: 10.w),
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
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Post Title',
                      hintStyle: TextStyle(color: theme.hintColor),
                      filled: true,
                      fillColor: theme.inputDecorationTheme.fillColor ?? Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: contentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Post Content',
                      hintStyle: TextStyle(color: theme.hintColor),
                      filled: true,
                      fillColor: theme.inputDecorationTheme.fillColor ?? Colors.grey[100],
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
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
              BlocBuilder<EditPostCubit, EditPostState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is EditPostLoading ? null : () {
                      final newTitle = titleController.text.trim();
                      final newContent = contentController.text.trim();
                      if (newTitle.isNotEmpty) {
                        final updatedData = {
                          'title': newTitle,
                          'content': newContent,
                          'attachments': currentPost.attachments,
                        };
                        context.read<EditPostCubit>().editPost(currentPost.id, updatedData);
                        Navigator.pop(dialogContext);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: state is EditPostLoading
                        ? SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                      ),
                    )
                        : const Text('Update'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return BlocProvider.value(
          value: context.read<DeletePostCubit>(),
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
              BlocBuilder<DeletePostCubit, DeletePostState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is DeletePostLoading ? null : () {
                      context.read<DeletePostCubit>().deletePost(currentPost.id);
                      Navigator.pop(dialogContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: state is DeletePostLoading
                        ? SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onError),
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
}

class PostProfileAvatar extends StatelessWidget {
  final Post post;

  const PostProfileAvatar({Key? key, required this.post}) : super(key: key);

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
        child: Image.network(
          UrlHelper.transformUrl(profilePictureURL),
          width: 28.r,
          height: 28.r,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _getDefaultAvatar(context);
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