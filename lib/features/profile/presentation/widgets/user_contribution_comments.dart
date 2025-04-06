import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/user_comments_model.dart';
import 'build_comments.dart';

class UserComments extends StatefulWidget {
  final userInfo;
  UserComments({super.key, this.userInfo});

  @override
  State<UserComments> createState() => _UserCommentsState();
}

class _UserCommentsState extends State<UserComments> {
  List<UserComment> userComment = UserComment.generateDummyUserComments(15);

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
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'No comments yet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          )
        : BuildComments(
            shrinkWrap: true,
            scrollPhysics: const BouncingScrollPhysics(),
            comments: userComment,
            userInfo: widget.userInfo,
            delete: _onCommentDelete,
          );
  }
}
