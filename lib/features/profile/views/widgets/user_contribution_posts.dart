import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../home/data/models/post_model.dart';
import '../../../home/views/widgets/build_posts.dart';

class UserPostsScreen extends StatefulWidget {
  final List<Post> posts;
  final void Function(Post post)? onDelete;
  final void Function(Post post, Map<String, dynamic> updatedData)? onEdit;

  const UserPostsScreen(
      {super.key, required this.posts, this.onDelete, this.onEdit});

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
      onDelete: widget.onDelete,
      onEdit: widget.onEdit,
      useForumCubit: false,
    );
  }
}
