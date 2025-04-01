import 'dart:math';

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
  });

  static List<Post> generateDummyPosts(int count) {
    const List<String> authors = [
      "Hassan",
      "Ahmed",
      "Mohamed",
      "Ali",
      "Maged",
      "Aslam"
    ];
    const List<String> avatars = [
      'assets/images/avatar1.jpg',
      'assets/images/avatar2.jpg',
      'assets/images/avatar3.jpg',
      'assets/images/avatar4.jpg',
      'assets/images/avatar5.jpg',
      'assets/images/avatar6.jpg',
    ];

    return List.generate(
      count,
      (index) {
        return Post(
          title: "Post title ${index + 1}",
          description:
              'This is a detailed description for post ${index + 1}. It contains a lot of information about the topic and might be quite lengthy. Users will need to expand this content to read the full post if it exceeds our character limit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam euismod, nisi vel consectetur euismod, nisi nisl aliquet nisi, eget consectetur nisl nisi vel nisi. Lorem ipsum dolor sit amet, consectetur adipiscing elit. This should definitely exceed our 200 character limit to demonstrate the read more functionality.',
          voteCount: _calculateVoteCount(index),
          upvote: _calculateVoteCount(index),
          downVote: (index + 1) * 3 - 4,
          author: authors[index % authors.length],
          avatar: avatars[index % avatars.length],
          time: (index + 1) * 2 - 1,
          commentCount: Random().nextInt(50),
        );
      },
    );
  }

  static int _calculateVoteCount(int index) {
    return index * 3 - 4;
  }
}
