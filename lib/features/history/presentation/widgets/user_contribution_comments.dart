import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/history/models/user_model.dart';
import 'package:flutterwidgets/features/history/presentation/widgets/build_comments.dart';

class UserComments extends StatelessWidget {
   UserComments({super.key});
   List<UserComment> userComment = UserComment.generateDummyUserComments(15);
  @override
  Widget build(BuildContext context) {
    return  BuildComments(shrinkWrap: true, scrollPhysics: const BouncingScrollPhysics(), comments: userComment,);
  }
}
