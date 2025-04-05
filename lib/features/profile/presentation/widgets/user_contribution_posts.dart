import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterwidgets/core/providers/user_provider.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';

import '../../../home/presentation/widgets/build_posts.dart';

class UserPostsScreen extends StatelessWidget {
  final userInfo;
  UserPostsScreen({super.key, this.userInfo});

  @override
  Widget build(BuildContext context) {
    // Use regular posts instead of UserPosts
    final posts = Post.generateDummyPosts(15);
    
    return BuildPosts(
      shrinkWrap: true,
      scrollPhysics: const BouncingScrollPhysics(),
      posts: posts,
      userInfo: userInfo,
    );
  }
}
