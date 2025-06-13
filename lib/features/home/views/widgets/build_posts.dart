import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/data/models/post_model.dart';
import 'package:flutterwidgets/features/home/views/widgets/post_item.dart';

import '../../../profile/views/widgets/no_profile_widget.dart';

class BuildPosts extends StatelessWidget {
  final bool shrinkWrap;
  final ScrollPhysics scrollPhysics;
  final List<Post> posts;
  final void Function(Post post)? onDelete;
  final void Function(Post post, Map<String, dynamic> updatedData)? onEdit;
  final bool useForumCubit;

  const BuildPosts({
    super.key,
    this.shrinkWrap = true,
    required this.scrollPhysics,
    required this.posts,
    this.onDelete,
    this.onEdit,
    this.useForumCubit = true,
  });

  @override
  Widget build(BuildContext context) {

    return posts.isEmpty
        ? NoDataWidget(
            message: "No posts yet... 👀",
            width: 100.w,
            height: 100.h,
          )
        : ListView.builder(
            shrinkWrap: shrinkWrap,
            physics: scrollPhysics,
            padding: EdgeInsets.zero,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostItem(
                post: posts[index],
                onDelete: onDelete,
                onEdit: onEdit,
                useForumCubit: useForumCubit,
              );
            },
          );
  }
}
