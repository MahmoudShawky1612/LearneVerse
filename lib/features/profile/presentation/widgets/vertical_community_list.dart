import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:flutterwidgets/features/profile/presentation/widgets/user_community_item.dart';

import 'no_profile_widget.dart';

class VerticalCommunityList extends StatelessWidget {
  final List<Community> communities;
  final void Function(BuildContext context, Community community)? onLeave;

  const VerticalCommunityList({super.key, required this.communities, this.onLeave});

  @override
  Widget build(BuildContext context) {
    return communities.isEmpty ? NoDataWidget(message: "Try to join communities and come here again... 😁", width: 100.w, height: 100.h,)
    : ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: communities.length,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            UserCommunityItem(
              community: communities[index],
              onLeave: onLeave == null ? null : () => onLeave!(context, communities[index]),
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
