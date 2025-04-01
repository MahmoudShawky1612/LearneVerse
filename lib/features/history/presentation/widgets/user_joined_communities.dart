import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/history/models/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VerticalCommunityList extends StatelessWidget {
   VerticalCommunityList({super.key});
  List<UserPost> userPosts = UserPost.generateDummyUserPosts(15);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      itemBuilder: (BuildContext context, int index) {
        return CommunityItem(
          post: userPosts[index],
        );
      },
    );
  }
}

class CommunityItem extends StatelessWidget {
final UserPost post;

  const CommunityItem({
    super.key,
    required this.post
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              post.communityImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.communityName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.userFriends,
                      size: 14,
                      color: Colors.blueGrey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "478 members",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("View"),
              ),
              const SizedBox(height: 5),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Leave", style: TextStyle(color: Colors.red.shade400)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
