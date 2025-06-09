import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutterwidgets/features/community/logic/cubit/forum_cubit.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_posts.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import '../../logic/cubit/forum.states.dart';
import '../../services/forum_service.dart';
import 'package:image/image.dart' as img;

class ForumTab extends StatefulWidget {
  final dynamic community;

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
    print(widget.community.id);
    context.read<ForumCubit>().fetchForumPosts(widget.community.id);
  }


  Future<String?> _uploadImage(File image) async {
    try {
      final fileSize = await image.length();
      if (fileSize > 10 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image size exceeds 10MB limit')),
        );
        return null;
      }

      // Convert image to JPEG
      final imageBytes = await image.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) {
        throw Exception('Failed to decode image');
      }
      final jpegBytes = img.encodeJpg(decodedImage, quality: 85);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image.jpg');
      await tempFile.writeAsBytes(jpegBytes);

      print('Converted image MIME type: ${lookupMimeType(tempFile.path)}'); // Debug log
      return await context.read<ForumApiService>().uploadImage(tempFile);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      print(e);
      return null;
    }
  }
  void _showCreatePostDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    XFile? pickedImage;
    final ImagePicker _picker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Create New Post'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(labelText: 'Content'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            setDialogState(() {
                              pickedImage = image;
                            });
                          }
                        },
                        child: const Text('Pick Image'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final XFile? image = await _picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (image != null) {
                            setDialogState(() {
                              pickedImage = image;
                            });
                          }
                        },
                        child: const Text('Take Photo'),
                      ),
                    ],
                  ),
                  if (pickedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Selected: ${pickedImage!.name}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                      List<String> attachments = [];
                      if (pickedImage != null) {
                        final imageUrl = await _uploadImage(File(pickedImage!.path));
                        if (imageUrl != null) {
                          attachments.add(imageUrl);
                        } else {
                          return; // Stop if image upload fails
                        }
                      }
                      context.read<ForumCubit>().createForumPost(
                        widget.community.id,
                        titleController.text,
                        contentController.text,
                        attachments,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post created successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Title and content are required')),
                      );
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
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
              return const Center(child: CupertinoActivityIndicator());
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
                ),
              );
            } else if (state is ForumFailure) {
              return Center(
                child: Text(
                  'Failed to load posts: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox(); // Default empty state
          },
        ),
      ],
    );
  }
}