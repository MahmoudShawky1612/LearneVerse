import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReplyInput extends StatelessWidget {
  final TextEditingController controller;
  final double maxWidth;
  final VoidCallback onSubmit;

  const ReplyInput({
    super.key,
    required this.controller,
    required this.maxWidth,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: maxWidth,
      margin: EdgeInsets.only(top: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Write a reply...',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 13.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                isDense: true,
              ),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 13.sp,
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            onPressed: onSubmit,
            icon: Icon(
              Icons.send,
              color: colorScheme.primary,
              size: 18.r,
            ),
            constraints: BoxConstraints(
              minWidth: 36.w,
              minHeight: 36.w,
            ),
            padding: EdgeInsets.all(5.r),
          ),
        ],
      ),
    );
  }
}