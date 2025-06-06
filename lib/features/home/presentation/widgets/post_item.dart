import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/home/data/models/post_model.dart';
import 'package:flutterwidgets/features/home/service/feed_post_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '.././../data/models/post_model.dart';
import '../../../profile/presentation/views/profile_screen.dart';

class PostItem extends StatefulWidget {
  final Post post;
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

  bool showOptions = false;



  Color upVoteColor = Colors.grey;
  Color downVoteColor = Colors.grey;
  final FeedPostsApiService _apiService = FeedPostsApiService();

  void upVote(int id)async{
    final count = await _apiService.upVotePost(id);
    if(count['type'] == 'UPVOTE') {
      setState(() {
        upVoteColor = Colors.green;
        downVoteColor = Colors.grey;
        widget.post.voteCounter = count['voteCount'];
      });
    } else if (count['type'] == 'NONE') {
      setState(() {
        upVoteColor = Colors.grey;
        widget.post.voteCounter = count['voteCount'];
      });
    }
  }

void downVote(int id)async{
  final count = await _apiService.downVotePost(id);
  if(count['type'] == 'DOWNVOTE') {
    setState(() {
      downVoteColor = Colors.red;
      upVoteColor = Colors.grey;
      widget.post.voteCounter = count['voteCount'];
    });
  } else if (count['type'] == 'NONE') {
    setState(() {
      downVoteColor = Colors.grey;
      widget.post.voteCounter = count['voteCount'];
    });
  }
}

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    final post = widget.post;
    final hoursAgo  = DateTime.now().difference(post.createdAt).inHours;
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
                    },
                    child: CircleAvatar(
                      radius: 16.r,
                      backgroundImage: NetworkImage(post.author.avatarUrl),
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
                                post.author.username,
                                style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
            Text('$hoursAgo h ago',
                            style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 11.sp)),
                      ],
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
                      post.content ?? ' ',
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          height: 1.4,
                          color: colorScheme.onSurface.withOpacity(0.9)),
                    ),
                    if (post.content!.length > 200)
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
                    post.attachments.isNotEmpty
                        ? Column(
                      children: post.attachments.map((attachmentUrl) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 8), // spacing between images
                          child: Image.network(
                            attachmentUrl,
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                    )
                        : Container(),

                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        _buildVoteButton(
                          icon: FontAwesomeIcons.arrowUp,
                          color: upVoteColor,
                          onTap: () => upVote(post.id),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${post.voteCounter}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        _buildVoteButton(
                          icon: FontAwesomeIcons.arrowDown,
                          color: downVoteColor,
                          onTap: () => downVote(post.id),
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
                              post.id, post.title, post.content ?? " " );
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
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: FaIcon(
        icon,
        size: 16.r,
        color: color
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

  void _showEditPostDialog(int id, String title, String content) {
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: content);
    final currentUser = widget.post.author;

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
                backgroundImage: AssetImage(currentUser.avatarUrl),
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
