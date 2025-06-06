import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/home/logic/cubit/post_feed_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/post_feed_states.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/post_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildPosts extends StatefulWidget {
  final shrinkWrap;
  final scrollPhysics;
  final posts;
  final userInfo;
  final Function? delete;
  final Function? edit;
  final isUserPost;

  const BuildPosts({
    super.key,
    this.shrinkWrap = true,
    required this.scrollPhysics,
    required this.posts,
    this.userInfo,
    this.delete,
    this.isUserPost = false,
    this.edit,
  });

  @override
  State<BuildPosts> createState() => _BuildPostsState();
}

class _BuildPostsState extends State<BuildPosts> {
  @override
  void initState() {
    super.initState();
    context.read<PostFeedCubit>().fetchFeedPosts();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return  BlocBuilder<PostFeedCubit, PostFeedState>(
      builder: (BuildContext context, PostFeedState state) {
        if (state is PostFeedLoading) {
          return const Center(child: CupertinoActivityIndicator());

        } else if (state is PostFeedError) {
          return Center(child: Text(state.message));
        } else if (state is PostFeedLoaded) {
          return ListView.separated(
              shrinkWrap: widget.shrinkWrap,
              physics: widget.scrollPhysics,
              padding: EdgeInsets.zero,
              itemCount: state.posts.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 0.5,
                color: theme.dividerColor.withOpacity(0.5),
              ),
              itemBuilder: (BuildContext context, int index) {
                return PostItem(
                  post: state.posts[index],
                  index: index,
                  userInfo: widget.userInfo,
                  delete: widget.delete,
                  isUserPost: widget.isUserPost,
                  edit: widget.edit,
                );
              });
        }
        return const Center(
          child: Text(
            'Unknown state',
            ),
        );

      },
    );
  }
}
