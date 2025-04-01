import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/history/presentation/widgets/user_contribution_posts.dart';

import '../../models/user_model.dart';
import 'comment_item.dart';

class BuildComments extends StatelessWidget {
  final bool shrinkWrap;
  final ScrollPhysics scrollPhysics;
  final List<UserComment> comments;

  const BuildComments({
    super.key,
    this.shrinkWrap = true,
    required this.scrollPhysics,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: scrollPhysics,
      itemCount: comments.length,
      itemBuilder: (BuildContext context, int index) {
        return CommentItem(comment: comments[index]);
      },
    );
  }
}
