import 'dart:math';

class Community {
  final int id;
  final String communityName;
  final String communityImage;

  Community({
    required this.id,
    required this.communityImage,
    required this.communityName,
  });
}

class Author {
  final int id;
  final String name;
  final String avatar;

  Author({
    required this.id,
    required this.name,
    required this.avatar,
  });
}

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
    final List<Author> author = [
      Author(
        id: 1,
        name: "Hassan",
        avatar: 'assets/images/avatar1.jpg',
      ),
      Author(
        id: 2,
        name: "Ahmed",
        avatar: 'assets/images/avatar2.jpg',
      ),
      Author(
        id: 3,
        name: "Mohamed",
        avatar: 'assets/images/avatar3.jpg',
      ),
      Author(
        id: 4,
        name: "Ali",
        avatar: 'assets/images/avatar4.jpg',
      ),
      Author(
        id: 5,
        name: "Maged",
        avatar: 'assets/images/avatar5.jpg',
      ),
      Author(
        id: 6,
        name: "Aslam",
        avatar: 'assets/images/avatar6.jpg',
      ),
    ];
    final List<Community> communities = [
      Community(
          id: 1,
          communityImage: 'assets/images/angular.jpg',
          communityName: "Angular"),
      Community(
          id: 2, communityImage: 'assets/images/c.jpg', communityName: "C"),
      Community(
          id: 3,
          communityImage: 'assets/images/go.jpg',
          communityName: "Go Lang"),
      Community(
          id: 4,
          communityImage: 'assets/images/js.jpg',
          communityName: "Java Script"),
      Community(
          id: 5,
          communityImage: 'assets/images/nodejs.jpg',
          communityName: "NodeJs"),
      Community(
          id: 6,
          communityImage: 'assets/images/post.jpg',
          communityName: "Postgres"),
      Community(
          id: 7,
          communityImage: 'assets/images/react.jpg',
          communityName: "React"),
      Community(
          id: 8,
          communityImage: 'assets/images/ts.jpg',
          communityName: "Type Script"),
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
          author: author[index % author.length].name,
          avatar: author[index % author.length].avatar,
          time: (index + 1) * 2 - 1,
          commentCount: Random().nextInt(50),
          communityImage:
              communities[index % communities.length].communityImage,
          communityName: communities[index % communities.length].communityName,
        );
      },
    );
  }

  static int _calculateVoteCount(int index) {
    return index * 3 - 4;
  }
}
