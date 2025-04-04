import 'package:flutter/cupertino.dart';

import '../../models/user_comments_model.dart';
import 'build_comments.dart';

class UserComments extends StatelessWidget {
  final userInfo;
  UserComments({super.key, this.userInfo});

  List<UserComment> userComment = UserComment.generateDummyUserComments(15);

  @override
  Widget build(BuildContext context) {
    return BuildComments(
      shrinkWrap: true,
      scrollPhysics: const BouncingScrollPhysics(),
      comments: userComment,
      userInfo:userInfo,
    );
  }
}
