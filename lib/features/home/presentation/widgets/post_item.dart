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

  late AnimationController _upvoteController;
  late AnimationController _downvoteController;
  late AnimationController _upvotePulseController;
  late AnimationController _downvotePulseController;
  late AnimationController _upvoteFloatController;
  late AnimationController _downvoteFloatController;

  @override
  void initState() {
    super.initState();
    voteCounter = widget.post.voteCounter;
    upVoteColor = widget.post.voteType == "UPVOTE" ? const Color(0xFF00E676) : Colors.grey;
    downVoteColor = widget.post.voteType == "DOWNVOTE" ? const Color(0xFFFF1744) : Colors.grey;

    _upvoteController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _downvoteController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _upvotePulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _downvotePulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _upvoteFloatController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _downvoteFloatController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _upvoteController.dispose();
    _downvoteController.dispose();
    _upvotePulseController.dispose();
    _downvotePulseController.dispose();
    _upvoteFloatController.dispose();
    _downvoteFloatController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final post = widget.post;
    final hoursAgo = DateTime.now().difference(post.createdAt).inHours;

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
                  backgroundImage: NetworkImage(post.author.avatarUrl),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.author.username,
                          style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 14.sp)),
                      SizedBox(height: 2.h),
                      Text('$hoursAgo h ago',
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
                    ...post.attachments.map((url) => Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Image.network(url, fit: BoxFit.cover),
                    )),

                  SizedBox(height: 12.h),

                  // Actions: Upvote / Downvote / Comment
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

                      // Downvote
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
                        text: '${post.commentCount}',
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
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
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
