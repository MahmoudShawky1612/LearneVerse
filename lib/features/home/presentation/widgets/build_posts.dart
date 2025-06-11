import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/home/data/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/post_item.dart';

import '../../../profile/presentation/widgets/no_profile_widget.dart';

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
    final theme = Theme.of(context);

    return posts.isEmpty ? const NoDataWidget(message: "No posts yet... 👀", width: 100, height: 100,)
    : ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: scrollPhysics,
      padding: EdgeInsets.zero,
      itemCount: posts.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        thickness: 0.5,
        color: theme.dividerColor.withOpacity(0.5),
      ),
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
