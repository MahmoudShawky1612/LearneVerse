import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';

import '../../../home/presentation/widgets/build_posts.dart';

class UserPosts extends StatelessWidget {
  List<Post> userPosts = Post.generateDummyPosts(15);

  @override
  Widget build(BuildContext context) {
    return BuildPosts(
      shrinkWrap: true,
      scrollPhysics: const BouncingScrollPhysics(),
      posts: userPosts,
    );
  }
}
