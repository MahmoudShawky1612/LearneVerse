import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../home/data/models/post_model.dart';
import '../../../home/presentation/widgets/build_posts.dart';

class UserPostsScreen extends StatefulWidget {
  final List<Post> posts;
  const UserPostsScreen({super.key, required this.posts});

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}


class _UserPostsScreenState extends State<UserPostsScreen> {
  @override
  Widget build(BuildContext context) {
    return BuildPosts(
      shrinkWrap: true,
      scrollPhysics: const BouncingScrollPhysics(),
      posts: widget.posts,
    );
  }
}
