import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/community/logic/cubit/forum_cubit.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:flutterwidgets/utils/error_state.dart';
import 'package:flutterwidgets/utils/jwt_helper.dart';
import 'package:flutterwidgets/utils/loading_state.dart';
import 'package:flutterwidgets/utils/snackber_util.dart';
import 'package:flutterwidgets/utils/url_helper.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../utils/token_storage.dart';
import '../../../home/views/widgets/build_posts.dart';
import '../../logic/cubit/forum.states.dart';
import '../../service/forum_service.dart';

class ForumTab extends StatefulWidget {
  final Community community;

  const ForumTab({
    super.key,
    required this.community,
  });

  @override
  State<ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> {
  @override
  void initState() {
    super.initState();
    context.read<ForumCubit>().fetchForumPosts(widget.community.id);
    _checkIfAuthor();
  }


  String? userPp;

  Future<void> _checkIfAuthor() async {
    final pP = await getUserPp();
    if (mounted) {
      setState(() {
        userPp = pP;
      });
    }
  }

  Future<dynamic> getUserPp() async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      return getUserProfilePictureURLFromToken(token);
    }
    return null;
  }

  Future<String?> _uploadImage(File image, BuildContext dialogContext) async {
    try {
      final fileSize = await image.length();
      if (fileSize > 10 * 1024 * 1024) {
        SnackBarUtils.showErrorSnackBar(
          dialogContext,
          message: 'Image size exceeds 10MB limit',
        );
        return null;
      }

      final imageBytes = await image.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) {
        throw Exception('Failed to decode image');
      }
      final jpegBytes = img.encodeJpg(decodedImage, quality: 85);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image_${image.hashCode}.jpg');
      await tempFile.writeAsBytes(jpegBytes);

      return await context.read<ForumApiService>().uploadImage(tempFile);
    } catch (e) {
      SnackBarUtils.showErrorSnackBar(
        dialogContext,
        message: 'Image upload failed: ${e.toString()}',
      );
       return null;
    }
  }

  void _showCreatePostDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    List<XFile> pickedImages = [];
    bool isCreating = false;
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(dialogContext).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(dialogContext).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with gradient
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(dialogContext).primaryColor,
                            Theme.of(dialogContext)
                                .primaryColor
                                .withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(28.r),
                          topRight: Radius.circular(28.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: CircleAvatar(
                              radius: 20.r,
                              backgroundColor: Colors.grey[200],
                              child: userPp != null && userPp!.isNotEmpty
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            UrlHelper.transformUrl(userPp!),
                                        width: 40.r,
                                        height: 40.r,
                                        fit: BoxFit.cover,
                                        errorWidget:
                                            (context, error, stackTrace) =>
                                                Icon(
                                          Icons.person,
                                          color: Colors.blue,
                                          size: 24.sp,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                      size: 24.sp,
                                    ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create New Post',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Share your thoughts with the community',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isCreating)
                            IconButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              icon: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Content - Scrollable
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          children: [
                            // Title Field
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(dialogContext).cardColor,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Theme.of(dialogContext)
                                      .dividerColor
                                      .withOpacity(0.1),
                                ),
                              ),
                              child: TextField(
                                controller: titleController,
                                enabled: !isCreating,
                                style: TextStyle(fontSize: 16.sp),
                                decoration: InputDecoration(
                                  labelText: 'Post Title',
                                  labelStyle: TextStyle(
                                    color: Theme.of(dialogContext).primaryColor,
                                    fontSize: 14.sp,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.title_rounded,
                                    color: Theme.of(dialogContext).primaryColor,
                                    size: 20.sp,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16.w),
                                ),
                              ),
                            ),

                            SizedBox(height: 16.h),

                            // Content Field
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(dialogContext).cardColor,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Theme.of(dialogContext)
                                      .dividerColor
                                      .withOpacity(0.1),
                                ),
                              ),
                              child: TextField(
                                controller: contentController,
                                enabled: !isCreating,
                                maxLines: 4,
                                style: TextStyle(fontSize: 16.sp),
                                decoration: InputDecoration(
                                  labelText: 'What\'s on your mind?',
                                  labelStyle: TextStyle(
                                    color: Theme.of(dialogContext).primaryColor,
                                    fontSize: 14.sp,
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(bottom: 60.h),
                                    child: Icon(
                                      Icons.edit_note_rounded,
                                      color:
                                          Theme.of(dialogContext).primaryColor,
                                      size: 20.sp,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16.w),
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h),

                            // Images Preview
                            if (pickedImages.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(bottom: 16.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.photo_library_rounded,
                                          color: Theme.of(dialogContext)
                                              .primaryColor,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          '${pickedImages.length} photo${pickedImages.length > 1 ? 's' : ''} selected',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(dialogContext)
                                                .primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    SizedBox(
                                      height: 120.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: pickedImages.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: 120.w,
                                            margin:
                                                EdgeInsets.only(right: 12.w),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              border: Border.all(
                                                color: Theme.of(dialogContext)
                                                    .primaryColor
                                                    .withOpacity(0.3),
                                                width: 2,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14.r),
                                                  child: Image.file(
                                                    File(pickedImages[index]
                                                        .path),
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Container(
                                                      color: Colors.grey[200],
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.person,
                                                          color: Colors.blue,
                                                          size: 40.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (!isCreating)
                                                  Positioned(
                                                    top: 4.w,
                                                    right: 4.w,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setDialogState(() {
                                                          pickedImages
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(4.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red
                                                              .withOpacity(0.9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r),
                                                        ),
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 12.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Image Picker Buttons
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Theme.of(dialogContext)
                                    .cardColor
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Theme.of(dialogContext)
                                      .dividerColor
                                      .withOpacity(0.1),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_rounded,
                                        color: Theme.of(context).primaryColor,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Add Photos',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.purple.withOpacity(0.1),
                                                Colors.blue.withOpacity(0.1),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            border: Border.all(
                                              color: Colors.purple
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              onTap: isCreating
                                                  ? null
                                                  : () async {
                                                      final List<XFile> images =
                                                          await picker
                                                              .pickMultiImage();
                                                      if (images.isNotEmpty) {
                                                        setDialogState(() {
                                                          pickedImages
                                                              .addAll(images);
                                                        });
                                                      }
                                                    },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12.h),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .photo_library_rounded,
                                                      color: Colors.purple,
                                                      size: 20.sp,
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      'Gallery',
                                                      style: TextStyle(
                                                        color: Colors.purple,
                                                        fontSize: 11.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.teal.withOpacity(0.1),
                                                Colors.green.withOpacity(0.1),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            border: Border.all(
                                              color:
                                                  Colors.teal.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              onTap: isCreating
                                                  ? null
                                                  : () async {
                                                      final XFile? image =
                                                          await picker
                                                              .pickImage(
                                                        source:
                                                            ImageSource.camera,
                                                      );
                                                      if (image != null) {
                                                        setDialogState(() {
                                                          pickedImages
                                                              .add(image);
                                                        });
                                                      }
                                                    },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12.h),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.camera_alt_rounded,
                                                      color: Colors.teal,
                                                      size: 20.sp,
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      'Camera',
                                                      style: TextStyle(
                                                        color: Colors.teal,
                                                        fontSize: 11.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 24.h),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: isCreating
                                        ? null
                                        : () => Navigator.pop(dialogContext),
                                    style: TextButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                      ),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(dialogContext)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(dialogContext).primaryColor,
                                          Theme.of(dialogContext)
                                              .primaryColor
                                              .withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(dialogContext)
                                              .primaryColor
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                        onTap: isCreating
                                            ? null
                                            : () async {
                                                if (titleController
                                                        .text.isNotEmpty &&
                                                    contentController
                                                        .text.isNotEmpty) {
                                                  setDialogState(() {
                                                    isCreating = true;
                                                  });

                                                  List<String> attachments = [];
                                                  for (var image
                                                      in pickedImages) {
                                                    final imageUrl =
                                                        await _uploadImage(
                                                            File(image.path),
                                                            dialogContext);
                                                    if (imageUrl != null) {
                                                      attachments.add(imageUrl);
                                                    } else {
                                                      setDialogState(() {
                                                        isCreating = false;
                                                      });
                                                      return;
                                                    }
                                                  }

                                                  context
                                                      .read<ForumCubit>()
                                                      .createForumPost(
                                                        widget.community.id,
                                                        titleController.text,
                                                        contentController.text,
                                                        attachments,
                                                      );
                                                  Navigator.pop(dialogContext);
                                                  SnackBarUtils
                                                      .showSuccessSnackBar(
                                                    context,
                                                    message:
                                                        'Post created successfully! 😃',
                                                  );
                                                } else {
                                                  SnackBarUtils
                                                      .showErrorSnackBar(
                                                    dialogContext,
                                                    message:
                                                        'Please fill in all fields. 😡',
                                                  );
                                                }
                                              },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (isCreating)
                                                SizedBox(
                                                  width: 20.w,
                                                  height: 20.w,
                                                  child:
                                                      const CupertinoActivityIndicator(),
                                                )
                                              else
                                                Icon(
                                                  Icons.send_rounded,
                                                  color: Colors.white,
                                                  size: 20.sp,
                                                ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                isCreating
                                                    ? 'Creating...'
                                                    : 'Create Post',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Community Forum',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showCreatePostDialog,
              icon: const Icon(Icons.add),
              label: const Text('New Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        BlocBuilder<ForumCubit, ForumStates>(
          builder: (context, state) {
            if (state is ForumLoading) {
              return Center(
                  child: Column(
                children: [
                  SizedBox(height: 20.h),
                  const LoadingState(),
                  SizedBox(height: 200.h),
                ],
              ));
            } else if (state is ForumSuccess) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: BuildPosts(
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  posts: state.posts,
                  useForumCubit: true,
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
