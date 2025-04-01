import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/history/models/user_model.dart';
import 'package:flutterwidgets/features/history/presentation/widgets/user_community_item.dart';

class VerticalCommunityList extends StatelessWidget {
  VerticalCommunityList({super.key});
  final List<UserPost> userPosts = UserPost.generateDummyUserPosts(15);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: userPosts.length,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      itemBuilder: (BuildContext context, int index) {
        return UserCommunityItem(
          post: userPosts[index],
        );
      },
    );
  }
}

