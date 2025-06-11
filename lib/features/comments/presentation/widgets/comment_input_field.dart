import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/jwt_helper.dart';
import '../../../../utils/token_storage.dart';
import '../../logic/cubit/comment_cubit.dart';
import '../../logic/cubit/comment_states.dart';

class CommentInputField extends StatefulWidget {
  final TextEditingController commentController;
  final void Function(String) createComment;

  const CommentInputField({
    super.key,
    required this.commentController,
    required this.createComment,
  });

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  String? pP; // Initialize as null
  bool isLoading = true; // Track loading state

  Future<void> _getPp() async {
    try {
      final token = await TokenStorage.getToken() ?? '';
      final pp = getUserProfilePictureURLFromToken(token);
      setState(() {
        pP = pp;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPp();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<CommentCubit, CommentStates>(
      listener: (context, state) {
        if (state is CommentLoading) {
          setState(() {
            isLoading = true; // Show loading indicator
          });
        } else {
          setState(() {
            isLoading = false; // Hide loading indicator
          });
        }
        if (state is CommentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is CommentCreated) {
          widget.commentController.clear();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0.w,
          vertical: 8.0.w,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -4),
              blurRadius: 8,
              color: colorScheme.primary.withOpacity(0.1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 36.r,
              height: 36.r,
              child: CircleAvatar(
                backgroundImage:
                pP != null && !isLoading ? NetworkImage(pP!) : null,
                radius: 18.r,
                backgroundColor: Colors.grey[200],
                child: isLoading
                    ? const CupertinoActivityIndicator(
                  radius: 10.0,
                  color: Colors.grey,
                )
                    : pP == null
                    ? Icon(Icons.person, color: Colors.grey[600])
                    : null,
              ),
            ),
            SizedBox(width: 8.0.w),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 40.h,
                ),
                child: TextField(
                  controller: widget.commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    hintStyle: TextStyle(
                      color: theme.hintColor,
                      fontSize: 14.sp,
                    ),
                    filled: true,
                    fillColor: theme.cardColor,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0.w,
                      vertical: 8.0.w,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.0.w),
            GestureDetector(
              onTap: () {
                final content = widget.commentController.text.trim();
                if (content.isNotEmpty) {
                  widget.createComment(content);
                }
              },
              child: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.onPrimary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: isLoading ? const CupertinoActivityIndicator() :Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}