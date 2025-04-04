import 'package:flutter/cupertino.dart';

import '../../models/user_comments_model.dart';
import 'build_comments.dart';

class UserComments extends StatelessWidget {
  final name;
  final image;
  UserComments({super.key, this.name, this.image});

  List<UserComment> userComment = UserComment.generateDummyUserComments(15);

  @override
  Widget build(BuildContext context) {
    return BuildComments(
      shrinkWrap: true,
      scrollPhysics: const BouncingScrollPhysics(),
      comments: userComment,
    );
  }
}
