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

  Author({
    required this.id,
    required this.name,
    required this.avatar,
    required this.userName,
    this.role = "Member",
    required this.points,
    required this.joinedCommunities,
  });

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

  static List<Author> users = [
    Author(
      id: 1,
      name: "Hassan",
      avatar: 'assets/images/avatar1.jpg',
      userName: "hassan",
      points: 0,
      // Placeholder, will be updated later
      joinedCommunities: userJoinedCommunities,
    ),
    Author(
      id: 2,
      name: "Ahmed",
      avatar: 'assets/images/avatar2.jpg',
      userName: "ahmed",
      points: 0,
      // Placeholder, will be updated later
      joinedCommunities: userJoinedCommunities,
    ),
    Author(
      id: 3,
      name: "Mohamed",
      avatar: 'assets/images/avatar3.jpg',
      userName: "mohamed",
      points: 0,
      // Placeholder, will be updated later
      joinedCommunities: userJoinedCommunities,
    ),
    Author(
      id: 4,
      name: "Ali",
      avatar: 'assets/images/avatar4.jpg',
      userName: "ali",
      points: 0,
      // Placeholder, will be updated later
      joinedCommunities: userJoinedCommunities,
    ),
    Author(
      id: 5,
      name: "Maged",
      avatar: 'assets/images/avatar5.jpg',
      userName: "maged",
      points: 0,
      // Placeholder, will be updated later
      joinedCommunities: userJoinedCommunities,
    ),
    Author(
      id: 6,
      name: "Aslam",
      avatar: 'assets/images/avatar6.jpg',
      userName: "aslam",
      points: 0,
      // Placeholder, will be updated later
      joinedCommunities: userJoinedCommunities,
    ),
  ];

  static List<Author> generateDummyAuthors() {
    return users;
  }

  static List<Author> generateMoreDummyAuthors() {
    int count =20;
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
        ),
      );
    }
    return moreAuthors;
  }

  static List<Author> searchUsers(String userName) {
    List<Author> foundUsers = [];
    for (int i = 0; i < users.length; i++) {
      if (users[i].name.toLowerCase().contains(userName.toLowerCase())) {
        foundUsers.add(users[i]);
      }
    }
    return foundUsers;
  }
}
