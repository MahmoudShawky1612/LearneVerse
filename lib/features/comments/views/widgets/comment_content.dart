import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/comments/views/widgets/replies_section.dart';
import 'package:flutterwidgets/features/comments/views/widgets/reply_input.dart';

import '../../../profile/views/widgets/comment_item.dart';
import '../../data/models/comment_model.dart';
import 'actions_row.dart';
import 'comment_header.dart';
import 'comment_text.dart';
import 'options_menu.dart' show OptionsMenu;

class CommentContent extends StatelessWidget {
  final Comment comment;
  final int nestingLevel;
  final double maxWidth;
  final bool isExpanded;
  final bool isReplying;
  final bool isAuthor;
  final bool isMenuVisible;
  final bool isLoadingChildren;
  final List<Comment> children;
  final Color upVoteColor;
  final Color downVoteColor;
  final int voteCounter;
  final TextEditingController replyController;
  final VoidCallback onToggleExpanded;
  final VoidCallback onToggleReply;
  final VoidCallback onSubmitReply;
  final VoidCallback onToggleMenu;
  final VoidCallback onShowEditDialog;
  final VoidCallback onShowDeleteDialog;

  const CommentContent({
    super.key,
    required this.comment,
    required this.nestingLevel,
    required this.maxWidth,
    required this.isExpanded,
    required this.isReplying,
    required this.isAuthor,
    required this.isMenuVisible,
    required this.isLoadingChildren,
    required this.children,
    required this.upVoteColor,
    required this.downVoteColor,
    required this.voteCounter,
    required this.replyController,
    required this.onToggleExpanded,
    required this.onToggleReply,
    required this.onSubmitReply,
    required this.onToggleMenu,
    required this.onShowEditDialog,
    required this.onShowDeleteDialog,
  });

  double get indentationWidth {
    const baseIndent = 12.0;
    const maxIndent = 40.0;
    return (baseIndent * nestingLevel).clamp(0.0, maxIndent);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: nestingLevel > 0 ? indentationWidth : 0, bottom: 6.h),
            decoration: BoxDecoration(
              border: nestingLevel > 0
                  ? Border(
                left: BorderSide(
                  color: _getThreadLineColor(colorScheme),
                  width: 2.w,
                ),
              )
                  : null,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: nestingLevel > 0 ? 14.w : 18.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommentHeader(
                    comment: comment,
                    isAuthor: isAuthor,
                    onToggleMenu: onToggleMenu,
                  ),
                  SizedBox(height: 10.h),
                  CommentText(
                    comment: comment,
                    maxWidth: maxWidth - (nestingLevel > 0 ? indentationWidth + 16.w : 32.w),
                  ),
                  SizedBox(height: 10.h),
                  ActionsRow(
                    comment: comment,
                    upVoteColor: upVoteColor,
                    downVoteColor: downVoteColor,
                    voteCounter: voteCounter,
                    hasChildren: comment.hasChildren || children.isNotEmpty,
                    isExpanded: isExpanded,
                    childrenCount: children.length,
                    onToggleReply: onToggleReply,
                    onToggleExpanded: onToggleExpanded,
                  ),
                  if (isReplying) ...[
                    SizedBox(height: 14.h),
                    ReplyInput(
                      controller: replyController,
                      maxWidth: maxWidth - (nestingLevel > 0 ? indentationWidth + 16.w : 32.w),
                      onSubmit: onSubmitReply,
                    ),
                  ],
                  if (isAuthor && isMenuVisible)
                    OptionsMenu(
                      maxWidth: maxWidth,
                      onEdit: onShowEditDialog,
                      onDelete: onShowDeleteDialog,
                    ),
                ],
              ),
            ),
          ),
          if (isExpanded && nestingLevel < 5)
            RepliesSection(
              nestingLevel: nestingLevel,
              maxWidth: maxWidth,
              isLoadingChildren: isLoadingChildren,
              children: children,
              comment: comment,
              onDelete: null, // Pass appropriate callbacks if needed
              onEdit: null,
            ),
        ],
      ),
    );
  }

  Color _getThreadLineColor(ColorScheme colorScheme) {
    final colors = [
      colorScheme.primary.withOpacity(0.3),
      colorScheme.secondary.withOpacity(0.3),
      colorScheme.tertiary.withOpacity(0.3),
      colorScheme.error.withOpacity(0.3),
      colorScheme.outline.withOpacity(0.3),
    ];
    return colors[nestingLevel % colors.length];
  }
}