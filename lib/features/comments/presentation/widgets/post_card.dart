import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../home/presentation/widgets/post_item.dart';

class PostCard extends StatelessWidget {
  final dynamic post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:   EdgeInsets.all(8.0.w),
      child: PostItem(post: post),
    );
  }
}
