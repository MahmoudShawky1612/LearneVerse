import '../../home/models/community_model.dart';

class UserComment {
  final String author;
  final String comment;
  final String repliedTo;
  int voteCount;
  final int upvote;
  final int downVote;
  final String avatar;
  final int time;
  final String communityName;
  final String communityImage;

  UserComment({
    this.author = "Dodje",
    required this.comment,
    required this.repliedTo,
    required this.voteCount,
    required this.upvote,
    required this.downVote,
    required this.avatar,
    required this.time,
    required this.communityName,
    required this.communityImage,
  });

  static List<UserComment> generateDummyUserComments(int count) {
    final communities = Community.generateDummyCommunities();

    return List.generate(count, (index) {
      final community = communities[index % communities.length];

      return UserComment(
        comment: "You can use Cubit for this one",
        repliedTo: "Sweet potato",
        voteCount: _calculateVoteCount(index),
        upvote: _calculateVoteCount(index),
        downVote: (index + 1) * 3 - 4,
        avatar: "assets/images/avatar.jpg",
        time: (index + 1) * 2 - 1,
        communityImage: community.image,
        communityName: community.name,
      );
    });
  }

  static int _calculateVoteCount(int index) => index * 3 - 4;
}
