import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/comments/data/models/comment_model.dart';

import 'comment_item.dart';

class BuildComments extends StatelessWidget {
  final bool shrinkWrap;
  final ScrollPhysics scrollPhysics;
  final List<Comment> comments;
  final bool flag;
  final Function? delete;
  final Function? edit;

  const BuildComments({
    super.key,
    this.shrinkWrap = true,
    required this.scrollPhysics,
    required this.comments,
    this.flag = true,
    this.delete,
    this.edit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: scrollPhysics,
      padding: EdgeInsets.zero,
      itemCount: comments.length,
      separatorBuilder: (context, index) => Divider(
        height: 1.h,
        thickness: 0.5,
        color: theme.dividerColor.withOpacity(0.5),
      ),
      itemBuilder: (BuildContext context, int index) {
        return CommentItem(
          comment: comments[index],
          flag: flag,
          delete: delete,
          edit: edit,
        );
      },
    );
  }
}
