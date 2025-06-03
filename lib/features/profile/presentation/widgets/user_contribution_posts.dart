import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';

import '../../../home/presentation/widgets/build_posts.dart';

class UserPostsScreen extends StatefulWidget {
  final userInfo;
  const UserPostsScreen({super.key, this.userInfo});

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}
final posts = Post.generateDummyPosts(15);

class _UserPostsScreenState extends State<UserPostsScreen> {
  @override
  Widget build(BuildContext context) {
    void onDeletePost(String id){
      setState(() {
        posts.removeWhere((p)=> p.id == id);
      });
    }

    void onEditPost(String id, String title, String description){
      setState(() {
        Post postToBeEdited = posts.firstWhere((p)=> p.id == id);
        postToBeEdited.title = title;
        postToBeEdited.description = description;
      });
    }

    return BuildPosts(
      shrinkWrap: true,
      scrollPhysics: const BouncingScrollPhysics(),
      posts: posts,
      userInfo: widget.userInfo,
      delete: onDeletePost,
      isUserPost: true,
      edit: onEditPost,
    );
  }
}
