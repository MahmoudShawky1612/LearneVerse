 import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../profile/views/widgets/comment_item.dart';
import '../../data/models/comment_model.dart';
import '../../logic/cubit/downvote_comment_cubit.dart';
import '../../logic/cubit/downvote_comment_states.dart';
import '../../logic/cubit/upvote_comment_cubit.dart';
import '../../logic/cubit/upvote_comment_states.dart';
import 'combact_action_button.dart';
import 'combact_vote_button.dart';

class ActionsRow extends StatelessWidget {
  final Comment comment;
  final Color upVoteColor;
  final Color downVoteColor;
  final int voteCounter;
  final bool hasChildren;
  final bool isExpanded;
  final int childrenCount;
  final VoidCallback onToggleReply;
  final VoidCallback onToggleExpanded;
  final VoidCallback? onUpvoteSuccess;
  final VoidCallback? onDownvoteSuccess;

  const ActionsRow({
    super.key,
    required this.comment,
    required this.upVoteColor,
    required this.downVoteColor,
    required this.voteCounter,
    required this.hasChildren,
    required this.isExpanded,
    required this.childrenCount,
    required this.onToggleReply,
    required this.onToggleExpanded,
    this.onUpvoteSuccess,
    this.onDownvoteSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14.w,
      runSpacing: 6.h,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocConsumer<UpvoteCommentCubit, UpVoteCommentStates>(
              listener: (context, state) {
                if (state is UpVoteCommentSuccess) {
                  if (onUpvoteSuccess != null) {
                    onUpvoteSuccess!();
                  }
                }
              },
              builder: (context, state) {
                return CompactVoteButton(
                  icon: Icons.arrow_upward,
                  color: upVoteColor,
                  isLoading: state is UpVoteCommentLoading,
                  onTap: () => context.read<UpvoteCommentCubit>().upVoteComment(comment),
                );
              },
            ),
            SizedBox(width: 6.w),
            Container(
              constraints: BoxConstraints(minWidth: 30.w),
              child: Text(
                '$voteCounter',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 6.w),
            BlocConsumer<DownvoteCommentCubit, DownVoteCommentStates>(
              listener: (context, state) {
                if (state is DownVoteCommentSuccess) {
                  if (onDownvoteSuccess != null) {
                    onDownvoteSuccess!();
                  }
                }
              },
              builder: (context, state) {
                return CompactVoteButton(
                  icon: Icons.arrow_downward,
                  color: downVoteColor,
                  isLoading: state is DownVoteCommentLoading,
                  onTap: () => context.read<DownvoteCommentCubit>().downVoteComment(comment),
                );
              },
            ),
          ],
        ),
        CompactActionButton(
          icon: Icons.reply,
          text: 'Reply',
          onTap: onToggleReply,
        ),
        if (hasChildren)
          CompactActionButton(
            icon: isExpanded ? Icons.expand_less : Icons.expand_more,
            text: isExpanded
                ? 'Hide $childrenCount ${childrenCount == 1 ? 'reply' : 'replies'}'
                : 'Show replies',
            onTap: onToggleExpanded,
          ),
      ],
    );
  }
}