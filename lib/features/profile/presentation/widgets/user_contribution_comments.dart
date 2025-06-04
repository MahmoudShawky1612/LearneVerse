import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/user_comments_model.dart';
import 'build_comments.dart';

class UserComments extends StatefulWidget {
  final userInfo;
  const UserComments({super.key, this.userInfo});

  @override
  State<UserComments> createState() => _UserCommentsState();
}

class _UserCommentsState extends State<UserComments> {
  List<UserComment> userComment = UserComment.generateDummyUserComments(15);

  void _onCommentEdit(String id, String commentDescription) {
    UserComment commentToBeEdited =
        userComment.firstWhere(((uc) => uc.id == id));
    setState(() {
      commentToBeEdited.comment = commentDescription;
    });
  }

  void _onCommentDelete(String id) {
    setState(() {
      userComment.removeWhere((uc) => uc.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return userComment.isEmpty
        ? Center(
            child: Padding(
              padding: EdgeInsets.all(20.0.w),
              child: Text(
                'No comments yet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          )
        : Column(
            children: [
              BuildComments(
                shrinkWrap: true,
                scrollPhysics: const BouncingScrollPhysics(),
                comments: userComment,
                userInfo: widget.userInfo,
                delete: _onCommentDelete,
                edit: _onCommentEdit,
              ),
              const Divider(),
            ],
          );
  }
}
