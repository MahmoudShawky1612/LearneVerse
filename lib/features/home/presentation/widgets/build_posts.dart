import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/post_item.dart';

class BuildPosts extends StatelessWidget {
  final bool shrinkWrap;
  final ScrollPhysics scrollPhysics;
  final List posts;
  final dynamic userInfo;
  final Function? delete;
  final Function? edit;
  final bool isUserPost;

  const BuildPosts({
    super.key,
    this.shrinkWrap = true,
    required this.scrollPhysics,
    required this.posts,
    this.userInfo,
    this.delete,
    this.isUserPost = false,
    this.edit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: scrollPhysics,
      padding: EdgeInsets.zero,
      itemCount: posts.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        thickness: 0.5,
        color: theme.dividerColor.withOpacity(0.5),
      ),
      itemBuilder: (context, index) {
        return PostItem(
          post: posts[index],
          delete: delete,
          isUserPost: isUserPost,
          edit: edit,
        );
      },
    );
  }
}
