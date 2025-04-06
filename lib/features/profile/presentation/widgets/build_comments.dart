import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/utils/responsive_utils.dart';

import 'comment_item.dart';

class BuildComments extends StatelessWidget {
  final bool shrinkWrap;
  final ScrollPhysics scrollPhysics;
  final comments;
  final bool flag;
  final userInfo;
  final Function? delete;

  const BuildComments({
    super.key,
    this.shrinkWrap = true,
    required this.scrollPhysics,
    required this.comments,
    this.flag = true, 
    this.userInfo, 
    this.delete,
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
        height: 1,
        thickness: 0.5,
        color: theme.dividerColor.withOpacity(0.5),
      ),
      itemBuilder: (BuildContext context, int index) {
        return CommentItem(
          comment: comments[index],
          flag: flag,
          userInfo: userInfo,
          delete: delete,
        );
      },
    );
  }
}
