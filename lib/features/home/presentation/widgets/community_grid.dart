import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/community_item.dart';

class CommunityGrid extends StatelessWidget {
  final List communities;

  const CommunityGrid({super.key, required this.communities});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 155.h,
      child: ListView.builder(
        itemCount: communities.length > 7 ? 7 : communities.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return CommunityItem(community: communities[index]);
        },
      ),
    );
  }
}
