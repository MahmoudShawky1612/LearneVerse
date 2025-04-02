import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import 'package:flutterwidgets/features/profile/presentation/widgets/user_community_item.dart';

class VerticalCommunityList extends StatelessWidget {
  final communities;

  const VerticalCommunityList({super.key, required this.communities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: communities.length,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      itemBuilder: (BuildContext context, int index) {
        return UserCommunityItem(
          community: communities[index],
        );
      },
    );
  }
}
