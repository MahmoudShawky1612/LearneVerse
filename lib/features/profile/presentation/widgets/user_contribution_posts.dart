import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../home/presentation/widgets/build_posts.dart';
import '../../models/user_posts_model.dart';

class UserPostsScreen extends StatelessWidget {
  final userInfo;
  UserPostsScreen({super.key, this.userInfo});

  List<UserPosts> userPosts = UserPosts.generateDummyUserPosts(15);

  @override
  Widget build(BuildContext context) {
    return BuildPosts(
      shrinkWrap: true,
      scrollPhysics: const BouncingScrollPhysics(),
      posts: userPosts,
      userInfo:userInfo,
    );
  }

}
