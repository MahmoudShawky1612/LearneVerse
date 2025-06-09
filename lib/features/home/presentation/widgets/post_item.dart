import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/home/data/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/vote_button.dart';
import 'package:flutterwidgets/features/home/service/feed_post_service.dart';
import 'package:flutterwidgets/features/home/logic/cubit/upvote_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/downvote_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/upvote_states.dart';
import 'package:flutterwidgets/features/home/logic/cubit/downvote_states.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/url_helper.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final dynamic userInfo;
  final Function? delete;
  final Function? edit;
  final  isUserPost;

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

class _PostItemState extends State<PostItem> with TickerProviderStateMixin {
  bool isExpanded = false;
  bool showOptions = false;
  late Color upVoteColor;
  late Color downVoteColor;
  late int voteCounter;
  late int commentCounter;


  @override
  void initState() {
    super.initState();
    voteCounter = widget.post.voteCounter;
    upVoteColor = widget.post.voteType == "UPVOTE" ? const Color(0xFF00E676) : Colors.grey;
    downVoteColor = widget.post.voteType == "DOWNVOTE" ? const Color(0xFFFF1744) : Colors.grey;
    commentCounter = widget.post.commentCount;
  }


  Widget _buildActionButton({required IconData icon, required String text, required VoidCallback onTap}) {
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
    print('Original URL: $imageUrl');
    print('Transformed URL: $transformedUrl');

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          transformedUrl,
          fit: BoxFit.cover,
          headers: {
            'ngrok-skip-browser-warning': 'true', // Skip ngrok warning
          },
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image: $error');
            print('URL: $transformedUrl');
            return Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.grey[600], size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'URL: $transformedUrl',
                      style: TextStyle(color: Colors.grey[500], fontSize: 10),
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
              height: 200,
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
                    SizedBox(height: 8),
                    Text('Loading image...', style: TextStyle(fontSize: 12)),
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
    final post = widget.post;

    return MultiBlocProvider(
      providers: [
        BlocProvider<UpvoteCubit>(
          create: (_) => UpvoteCubit(FeedPostsApiService()),
        ),
        BlocProvider<DownvoteCubit>(
          create: (_) => DownvoteCubit(FeedPostsApiService()),
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
                CircleAvatar(
                  radius: 16.r,
                  backgroundImage: NetworkImage(UrlHelper.transformUrl(post.author.profilePictureURL)),
                  backgroundColor: Colors.transparent,
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Error loading profile picture: $exception');
                  },
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.author.fullname,
                          style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 14.sp)),
                      SizedBox(height: 2.h),
                      Text('${_getTimeAgo(post.createdAt)} ago',
                          style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 11.sp)),
                    ],
                  ),
                ),
                if (widget.isUserPost)
                  IconButton(
                    icon: Icon(Icons.more_horiz, size: 18.r),
                    onPressed: () => setState(() => showOptions = !showOptions),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.w),
                  ),
              ],
            ),
            SizedBox(height: 12.h),

            // Content
            Padding(
              padding: EdgeInsets.only(left: 40.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title,
                      style: textTheme.titleMedium?.copyWith(
                          fontSize: 16.sp, fontWeight: FontWeight.w700)),
                  SizedBox(height: 8.h),
                  Text(post.content ?? '',
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(fontSize: 14.sp, height: 1.4)),
                  if (post.content != null && post.content!.length > 200)
                    GestureDetector(
                      onTap: () => setState(() => isExpanded = !isExpanded),
                      child: Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: Text(isExpanded ? 'Show less' : 'Read more',
                            style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp)),
                      ),
                    ),
                  if (post.attachments.isNotEmpty)
                    ...post.attachments.map((url) => _buildImageWidget(url)),
                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      // Upvote
                      BlocConsumer<UpvoteCubit, UpVoteStates>(
                        listener: (context, state) {
                          if (state is UpVoteSuccess) {
                            setState(() {
                              voteCounter = post.voteCounter;
                              upVoteColor = post.voteType == "UPVOTE" ? const Color(0xFF00E676) : Colors.grey;
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
                            onTap: () => context.read<UpvoteCubit>().upVote(post),
                          );
                        },
                      ),
                      SizedBox(width: 4.w),
                      Text('$voteCounter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                      SizedBox(width: 10.w),

                      BlocConsumer<DownvoteCubit, DownVoteStates>(
                        listener: (context, state) {
                          if (state is DownVoteSuccess) {
                            setState(() {
                              voteCounter = post.voteCounter;
                              downVoteColor = post.voteType == "DOWNVOTE" ? const Color(0xFFFF1744) : Colors.grey;
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
                            onTap: () => context.read<DownvoteCubit>().downVote(post),
                          );
                        },
                      ),
                      SizedBox(width: 20.w),

                      // Comments
                      _buildActionButton(
                        icon: FontAwesomeIcons.comment,
                        text: '$commentCounter',
                        onTap: () => context.push('/comments', extra: post),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Show delete/edit options
            if (showOptions)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 8.h),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.edit != null)
                        TextButton.icon(
                          onPressed: () => widget.edit!(),
                          icon: Icon(Icons.edit, size: 18.sp),
                          label: Text("Edit", style: TextStyle(fontSize: 13.sp)),
                        ),
                      if (widget.delete != null)
                        TextButton.icon(
                          onPressed: () => widget.delete!(),
                          icon: Icon(Icons.delete, size: 18.sp, color: Colors.red),
                          label: Text("Delete", style: TextStyle(fontSize: 13.sp, color: Colors.red)),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
