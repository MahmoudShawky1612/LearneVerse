import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/comments/data/models/comment_model.dart';

import 'build_comments.dart';

class UserComments extends StatefulWidget {
  final List<Comment> comments;
  const UserComments({super.key, required this.comments});

  @override
  State<UserComments> createState() => _UserCommentsState();
}

class _UserCommentsState extends State<UserComments> {
  void _onCommentEdit(String id, String commentDescription) {
    // TODO: Implement edit logic
  }

  void _onCommentDelete(String id) {
    // TODO: Implement delete logic
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: BuildComments(
              shrinkWrap: true,
              scrollPhysics: const ClampingScrollPhysics(),
              comments: widget.comments,
            ),
          ),
          Divider(height: 1.h),
        ],
      ),
    );
  }
}
