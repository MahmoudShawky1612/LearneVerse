import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/post_item.dart';

class BuildPosts extends StatelessWidget {
  final shrinkWrap;
  final scrollPhysics;
  final posts;
  final userInfo;

  const BuildPosts(
      {super.key,
      this.shrinkWrap = true,
      required this.scrollPhysics,
      required this.posts,
      this.userInfo});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: shrinkWrap,
        physics: scrollPhysics,
        padding: EdgeInsets.zero,
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return PostItem(
            post: posts[index],
            userInfo: userInfo,
          );
        });
  }
}
