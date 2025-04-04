import 'dart:math';

import 'package:flutterwidgets/features/home/models/community_model.dart';

class Author {
  final int id;
  final String userName;
  final String name;
  final String avatar;
  final String role;
  final int points;
  final List<Community> joinedCommunities;
  final String quote;
  final int totalJoinedCommunities;
  final int totalPostUpvotes;
  final int totalCommentUpvotes;

  Author({
    required this.id,
    required this.name,
    required this.avatar,
    required this.userName,
    this.role = "Member",
    required this.points,
    required this.joinedCommunities,
    required this.quote,
    required this.totalJoinedCommunities,
    required this.totalPostUpvotes,
    required this.totalCommentUpvotes,
  });

  static final List<String> quotes = [
    "العبقرية ليست سوى الألم والمثابرة.",
    "العقل البشري مثل المظلة، لا يعمل إلا عندما يكون مفتوحًا.",
    "قد تنسى الذي ضحكت معه، لكن لن تنسى الذي بكيت معه.",
    "الخوف لا يمنع من الموت، لكنه يمنع من الحياة.",
    "حين تحب لا تتمسك بالقيد، بل أعطِ الحرية لمن تحب.",
    "If you only read the books that everyone else is reading, you can only think what everyone else is thinking.",
    "Life is just an illusion, and bad times are just reflections of that illusion.",
    "Freedom means responsibility; that is why most men dread it.",
    "Do not compare your life to others. You have no idea what they have been through.",
    "Be yourself; everyone else is already taken.",
    "Happiness is not something ready-made. It comes from your own actions.",
    "If you want to change the world, start by changing yourself.",
  ];

  static final Random _random = Random();

  static List<Community> userJoinedCommunities = [
    Community(
        id: 1,
        image: 'assets/images/angular.jpg',
        name: "Angular",
        memberCount: 328,
        tags: ['angular', 'advanced'],
        communityPrivacy: 'Public',
        communityBackgroundImage: 'assets/images/angular1.jpg',
        rating: 4.5,
        reviews: 120),
    Community(
        id: 2,
        image: 'assets/images/c.jpg',
        name: "C",
        memberCount: 245,
        tags: ['beginner', 'c'],
        communityPrivacy: 'Public',
        communityBackgroundImage: 'assets/images/c1.jpg',
        rating: 2.2,
        reviews: 90),
    Community(
        id: 3,
        image: 'assets/images/go.jpg',
        name: "Go Lang",
        memberCount: 356,
        tags: ['beginner', 'go lang'],
        communityPrivacy: 'Public',
        communityBackgroundImage: 'assets/images/go1.jpg',
        rating: 4.6,
        reviews: 150),
    Community(
        id: 4,
        image: 'assets/images/js.jpg',
        name: "JavaScript",
        memberCount: 134,
        tags: ['problem solving'],
        communityPrivacy: 'Private',
        communityBackgroundImage: 'assets/images/js1.jpg',
        rating: 4.7,
        reviews: 180),
  ];

  static int jCL = userJoinedCommunities.length;
  static List<Author> users = List.generate(6, (index) {
    return Author(
      id: index + 1,
      name: ["Hassan", "Ahmed", "Mohamed", "Ali", "Maged", "Aslam"][index],
      avatar: 'assets/images/avatar${index + 1}.jpg',
      userName: ["hassan", "ahmed", "mohamed", "ali", "maged", "aslam"][index],
      points: 0,
      joinedCommunities: userJoinedCommunities,
      quote: quotes[_random.nextInt(quotes.length)],
      totalJoinedCommunities: jCL,
      totalPostUpvotes: _random.nextInt(2533),
      totalCommentUpvotes: _random.nextInt(2533),
    );
  });

  static List<Author> generateDummyAuthors() {
    return users;
  }

  static List<Author> generateMoreDummyAuthors() {
    int count = 20;
    List<Author> moreAuthors = [];
    Random random = Random();

    int baseId = users.length + 1;
    List<int> points = List.generate(count, (index) => random.nextInt(701));
    points.sort((a, b) => b.compareTo(a));

    for (int i = 0; i < count; i++) {
      moreAuthors.add(
        Author(
          id: baseId + i,
          name: users[i % users.length].name,
          avatar: users[i % users.length].avatar,
          userName: users[i % users.length].userName,
          points: points[i],
          joinedCommunities: userJoinedCommunities,
          quote: quotes[random.nextInt(quotes.length)],
          totalJoinedCommunities: jCL,
          totalPostUpvotes: random.nextInt(2533),
          totalCommentUpvotes: random.nextInt(2533),
        ),
      );
    }
    return moreAuthors;
  }

  static List<Author> searchUsers(String userName) {
    return users
        .where((user) =>
        user.name.toLowerCase().contains(userName.toLowerCase()))
        .toList();
  }
}
