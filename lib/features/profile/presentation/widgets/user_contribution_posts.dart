import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterwidgets/core/providers/user_provider.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';

import '../../../home/presentation/widgets/build_posts.dart';

class UserPostsScreen extends StatefulWidget {
  final userInfo;
  UserPostsScreen({super.key, this.userInfo});

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}
final posts = Post.generateDummyPosts(15);

class _UserPostsScreenState extends State<UserPostsScreen> {
  @override
  Widget build(BuildContext context) {
    // Use regular posts instead of UserPosts
    void onDeletePost(String id){
      setState(() {
        posts.removeWhere((p)=> p.id == id);
      });
    }

    return BuildPosts(
      shrinkWrap: true,
      scrollPhysics: const BouncingScrollPhysics(),
      posts: posts,
      userInfo: widget.userInfo,
      delete: onDeletePost,
    );
  }
}
