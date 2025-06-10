import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/home/data/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/post_item.dart';

class BuildPosts extends StatelessWidget {
  final bool shrinkWrap;
  final ScrollPhysics scrollPhysics;
  final List<Post> posts;


  const BuildPosts({
    super.key,
    this.shrinkWrap = true,
    required this.scrollPhysics,
    required this.posts,

  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return posts.isEmpty ? const Center(child: Text("No Posts Yet 😔"),) : ListView.separated(
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
        );
      },
    );
  }
}
