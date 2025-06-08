import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/community/logic/cubit/forum.states.dart';
import 'package:flutterwidgets/features/community/logic/cubit/forum_cubit.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_posts.dart';
import '../../logic/cubit/single_community_cubit.dart';
import '../../logic/cubit/single_community_states.dart';
import 'create_post_dialog.dart';

class ForumTab extends StatefulWidget {
  final VoidCallback onCreatePost;
  final dynamic community;
  final Future<void> Function() imagePicker;

  const ForumTab({
    super.key,
    required this.onCreatePost,
    required this.community,
    required this.imagePicker,
  });

  @override
  State<ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> {
  @override
  void initState() {
    super.initState();
    print(widget.community.id);
    context.read<ForumCubit>().fetchForumPosts(widget.community.id);
  }

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
        BlocBuilder<ForumCubit, ForumStates>(
          builder: (context, state) {
            if (state is ForumLoading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is ForumSuccess) {
              return Container(
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
                  posts: state.posts,
                ),
              );
            } else if (state is ForumFailure) {
              return Center(
                child: Text(
                  'Failed to load posts: ${state.message}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox(); // Default empty state
          },
        ),
      ],
    );
  }
}
