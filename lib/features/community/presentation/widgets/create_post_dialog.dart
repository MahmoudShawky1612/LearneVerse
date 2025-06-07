import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';

class CreatePostDialog extends StatelessWidget {
  final Author currentUser;
  final dynamic community;
  final void  onCreatePost;
  final Future<void> Function() imagePicker;

  const CreatePostDialog({
    super.key,
    required this.currentUser,
    required this.community,
    required this.onCreatePost,
    required this.imagePicker,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = theme.extension<AppThemeExtension>();

    return AlertDialog(
      backgroundColor: theme.cardColor,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(currentUser.avatar),
            radius: 16.r,
          ),
          SizedBox(width: 10.w),
          Text(
            'Create Post',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: theme.hintColor),
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor ??
                    theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: descriptionController,
              style: TextStyle(color: colorScheme.onSurface),
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: theme.hintColor),
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor ??
                    theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            IconButton(
              onPressed: imagePicker,
              icon: const Icon(Icons.image_outlined),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: themeExtension?.buttonGradient,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
              }
            },
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}