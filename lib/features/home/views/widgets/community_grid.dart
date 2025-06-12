import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:flutterwidgets/features/home/views/widgets/community_item.dart';

class CommunityGrid extends StatelessWidget {
  final List<Community> communities;
  final isFavoriteCommunity;
  const CommunityGrid(
      {super.key, required this.communities, this.isFavoriteCommunity = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 155.h,
      child: ListView.builder(
        itemCount: communities.length > 7 ? 7 : communities.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return CommunityItem(
              community: communities[index],
              isFavoriteCommunity: isFavoriteCommunity);
        },
      ),
    );
  }
}
