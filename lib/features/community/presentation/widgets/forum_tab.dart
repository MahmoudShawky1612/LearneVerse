import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_posts.dart';
import 'create_post_dialog.dart';

class ForumTab extends StatelessWidget {
  final List<Post> posts;
  final VoidCallback onCreatePost;
  final dynamic community;
  final Author currentUser;
  final Future<void> Function() imagePicker;

  const ForumTab({
    super.key,
    required this.posts,
    required this.onCreatePost,
    required this.community,
    required this.currentUser,
    required this.imagePicker,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Community Forum',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CreatePostDialog(
                    currentUser: currentUser,
                    community: community,
                    onCreatePost: onCreatePost,
                    imagePicker: imagePicker,
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('New Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: BuildPosts(
            scrollPhysics: const NeverScrollableScrollPhysics(),
            posts: posts,
          ),
        ),
      ],
    );
  }
}