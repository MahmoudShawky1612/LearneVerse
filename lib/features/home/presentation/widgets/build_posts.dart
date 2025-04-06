import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/utils/responsive_utils.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/post_item.dart';

class BuildPosts extends StatelessWidget {
  final shrinkWrap;
  final scrollPhysics;
  final posts;
  final userInfo;
  final Function? delete;
  final Function? edit;
  final isUserPost;

  const BuildPosts({
    super.key,
    this.shrinkWrap = true,
    required this.scrollPhysics,
    required this.posts,
    this.userInfo,
    this.delete, this.isUserPost=false, this.edit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return posts.isEmpty 
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'No posts yet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          )
        : ListView.separated(
            shrinkWrap: shrinkWrap,
            physics: scrollPhysics,
            padding: EdgeInsets.zero,
            itemCount: posts.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 0.5,
              color: theme.dividerColor.withOpacity(0.5),
            ),
            itemBuilder: (BuildContext context, int index) {
              return PostItem(
                post: posts[index],
                userInfo: userInfo,
                delete: delete,
                isUserPost:isUserPost,
                edit: edit,
              );
            });
  }
}
