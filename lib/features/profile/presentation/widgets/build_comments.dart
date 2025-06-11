import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/comments/data/models/comment_model.dart';

import 'comment_item.dart';

class BuildComments extends StatelessWidget {
  final bool shrinkWrap;
  final ScrollPhysics scrollPhysics;
  final List<Comment> comments;
  final void Function(Comment comment)? onDelete;
  final void Function(Comment comment, String newContent)? onEdit;

  const BuildComments({
    super.key,
    this.shrinkWrap = true,
    required this.scrollPhysics,
    required this.comments,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return comments.isEmpty? Center(child: Text("No Comments Yet 🙁"),) :ListView.separated(
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
          onDelete: onDelete,
          onEdit: onEdit,
        );
      },
    );
  }
}
