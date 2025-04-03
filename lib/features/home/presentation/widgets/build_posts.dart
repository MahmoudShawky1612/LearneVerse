import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/post_item.dart';


class BuildPosts extends StatelessWidget {
  final  shrinkWrap;
  final  scrollPhysics;
  final posts;
   const BuildPosts({super.key, this.shrinkWrap=true, required this.scrollPhysics, required this.posts});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: shrinkWrap,
        physics:  scrollPhysics,
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return PostItem(post: posts[index]);
        });
  }
}
