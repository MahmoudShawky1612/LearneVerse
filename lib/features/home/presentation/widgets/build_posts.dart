import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/post_item.dart';

class BuildPosts extends StatelessWidget {
  const BuildPosts({super.key});

  @override
  Widget build(BuildContext context) {
    final List _authors = [
      "Hassan",
      'Ahmed',
      'Mohamed',
      'Ali',
      'Maged',
      'Aslam',
    ];
    final List _avatars = [
      'assets/images/avatar1.jpg',
      'assets/images/avatar2.jpg',
      'assets/images/avatar3.jpg',
      'assets/images/avatar4.jpg',
      'assets/images/avatar5.jpg',
      'assets/images/avatar6.jpg',
    ];
    final List<Map<String, dynamic>> _posts = List.generate(
        10,
        (index) => {
              "title": "Post title ${index + 1}",
              "description":
                  'This is a detailed description for post ${index + 1}. It contains a lot of information about the topic and might be quite lengthy. Users will need to expand this content to read the full post if it exceeds our character limit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam euismod, nisi vel consectetur euismod, nisi nisl aliquet nisi, eget consectetur nisl nisi vel nisi. Lorem ipsum dolor sit amet, consectetur adipiscing elit. This should definitely exceed our 200 character limit to demonstrate the read more functionality.',
              "voteCount": index * 3 - 4,
              "upvote": index * 3 - 4,
              "downVote": (index + 1) * 3 - 4,
              "author": _authors[index % _authors.length],
              "avatar": _avatars[index % _avatars.length],
              "time": (index + 1) * 2 - 1,
              "commentCount": Random().nextInt(50),
            });
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _posts.length,
        itemBuilder: (BuildContext context, int index) {
          return PostItem(post: _posts[index]);
        });
  }
}
