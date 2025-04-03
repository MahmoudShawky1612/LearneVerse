import 'package:flutter/cupertino.dart';

import '../../models/user_comments_model.dart';
import 'comment_item.dart';

class BuildComments extends StatelessWidget {
  final bool shrinkWrap;
  final ScrollPhysics scrollPhysics;
  final comments;
  final bool flag;

  const BuildComments({
    super.key,
    this.shrinkWrap = true,
    required this.scrollPhysics,
    required this.comments,
    this.flag = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: scrollPhysics,
      itemCount: comments.length,
      itemBuilder: (BuildContext context, int index) {
        return CommentItem(
          comment: comments[index],
          flag: flag,
        );
      },
    );
  }
}
