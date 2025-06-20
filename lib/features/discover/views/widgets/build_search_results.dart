import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/community/data/models/community_members_model.dart';
import 'package:flutterwidgets/features/discover/views/widgets/build_section_title.dart';
import 'package:flutterwidgets/features/discover/views/widgets/vertical_users_list.dart';
import '../../../home/data/models/community_model.dart';
import '../../../profile/views/widgets/vertical_community_list.dart';

class BuildSearchResults extends StatelessWidget {
  final List<Community> foundCommunities;
  final List<CommunityMember> foundUsers;

  const BuildSearchResults({
    super.key,
    required this.foundCommunities,
    required this.foundUsers,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: EdgeInsets.only(bottom: 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (foundCommunities.isNotEmpty) ...[
              const BuildSectionTitle(title: "Communities"),
              VerticalCommunityList(
                communities: foundCommunities,
              ),
            ],
            if (foundUsers.isNotEmpty) ...[
              const BuildSectionTitle(title: "People"),
              VerticalUserList(users: foundUsers),
            ],
          ],
        ),
      ),
    );
  }
}
