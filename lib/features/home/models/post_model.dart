import 'dart:math';

import 'author_model.dart';
import 'community_model.dart';


class Post {
  final String title;
  final String description;
  int voteCount;
  final int upvote;
  final int downVote;
  final String author;
  final String avatar;
  final int time;
  final int commentCount;
  final String communityName;
  final String communityImage;

  Post({
    required this.title,
    required this.description,
    required this.voteCount,
    required this.upvote,
    required this.downVote,
    required this.author,
    required this.avatar,
    required this.time,
    required this.commentCount,
    required this.communityName,
    required this.communityImage,
  });

  static List<Post> generateDummyPosts(int count) {
    final authors = Author.generateDummyAuthors();
    final communities = Community.generateDummyCommunities();

    return List.generate(count, (index) {
      final author = authors[index % authors.length];
      final community = communities[index % communities.length];

      return Post(
        title: "Post title ${index + 1}",
        description: "This is a detailed description for post ${index + 1}...",
        voteCount: _calculateVoteCount(index),
        upvote: _calculateVoteCount(index),
        downVote: (index + 1) * 3 - 4,
        author: author.name,
        avatar: author.avatar,
        time: (index + 1) * 2 - 1,
        commentCount: Random().nextInt(50),
        communityImage: community.image,
        communityName: community.name,
      );
    });
  }

  static int _calculateVoteCount(int index) => index * 3 - 4;
}