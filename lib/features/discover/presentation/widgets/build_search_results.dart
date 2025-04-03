import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/discover/presentation/widgets/build_section_title.dart';
import 'package:flutterwidgets/features/discover/presentation/widgets/vertical_users_list.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import '../../../profile/presentation/widgets/vertical_community_list.dart';

class BuildSearchResults extends StatelessWidget {
  final List<Community> foundCommunities;
  final List<Author> foundUsers;

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
        margin: const EdgeInsets.only(bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (foundCommunities.isNotEmpty) ...[
              const BuildSectionTitle(title: "Communities"),
              VerticalCommunityList(communities: foundCommunities, flag: false,),
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