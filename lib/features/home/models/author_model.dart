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
  final List<String> interests;

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
    required this.interests,
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

  static final List<String> allInterests = [
    'Programming', 'Web Development', 'Mobile Apps', 'Machine Learning', 
    'Data Science', 'UI/UX', 'DevOps', 'Cybersecurity', 'Blockchain',
    'Cloud Computing', 'Game Development', 'IoT', 'AR/VR', 'Python',
    'JavaScript', 'Java', 'React', 'Flutter', 'Node.js', 'Angular',
    'AWS', 'Docker', 'Kubernetes', 'Algorithms', 'System Design'
  ];

  static List<String> getRandomInterests() {
    final numberOfInterests = _random.nextInt(4) + 2; // 2-5 interests
    List<String> interests = [];
    List<String> availableInterests = List.from(allInterests);
    
    for (int i = 0; i < numberOfInterests; i++) {
      if (availableInterests.isEmpty) break;
      final index = _random.nextInt(availableInterests.length);
      interests.add(availableInterests[index]);
      availableInterests.removeAt(index);
    }
    
    return interests;
  }

  static List<Community> userJoinedCommunities = [
    // Web development focused communities
    Community(
        id: 1,
        image: 'assets/images/angular.jpg',
        name: "Angular",
        memberCount: 328,
        tags: ['Angular', 'Web Development', 'JavaScript', 'UI/UX', 'Frontend'],
        communityPrivacy: 'Public',
        communityBackgroundImage: 'assets/images/angular1.jpg',
        rating: 4.5,
        reviews: 120),
    Community(
        id: 4,
        image: 'assets/images/js.jpg',
        name: "JavaScript",
        memberCount: 134,
        tags: ['JavaScript', 'Web Development', 'React', 'Node.js', 'Frontend'],
        communityPrivacy: 'Private',
        communityBackgroundImage: 'assets/images/js1.jpg',
        rating: 4.7,
        reviews: 180),
    Community(
        id: 7,
        image: 'assets/images/react.jpg',
        name: "React",
        memberCount: 700,
        tags: ['React', 'JavaScript', 'Web Development', 'UI/UX', 'Frontend'],
        communityPrivacy: 'Public',
        communityBackgroundImage: 'assets/images/react1.jpg',
        rating: 3.1,
        reviews: 300),
    // Mobile development focused communities
    Community(
        id: 10,
        image: 'assets/images/flutter.jpg',
        name: "Flutter",
        memberCount: 850,
        tags: ['Flutter', 'Mobile Apps', 'Dart', 'UI/UX', 'Cross-platform'],
        communityPrivacy: 'Public',
        communityBackgroundImage: 'assets/images/flutter1.jpg',
        rating: 4.7,
        reviews: 320),
    // Data science focused communities
    Community(
        id: 9,
        image: 'assets/images/python.jpg',
        name: "Python",
        memberCount: 1500,
        tags: ['Python', 'Programming', 'Machine Learning', 'Data Science', 'Algorithms'],
        communityPrivacy: 'Public',
        communityBackgroundImage: 'assets/images/python1.jpg',
        rating: 4.9,
        reviews: 450),
    // System programming focused communities
    Community(
        id: 2,
        image: 'assets/images/c.jpg',
        name: "C",
        memberCount: 245,
        tags: ['C', 'Programming', 'Algorithms', 'System Design', 'Performance'],
        communityPrivacy: 'Public',
        communityBackgroundImage: 'assets/images/c1.jpg',
        rating: 2.2,
        reviews: 90),
  ];

  static int jCL = userJoinedCommunities.length;
  static List<Author> users = [
    Author(
      id: 1,
      name: "Hassan",
      avatar: 'assets/images/avatar1.jpg',
      userName: "hassan",
      points: 450,
      joinedCommunities: userJoinedCommunities,
      quote: quotes[_random.nextInt(quotes.length)],
      totalJoinedCommunities: jCL,
      totalPostUpvotes: _random.nextInt(2533),
      totalCommentUpvotes: _random.nextInt(2533),
      interests: ['Web Development', 'JavaScript', 'React', 'Node.js', 'UI/UX'],
    ),
    Author(
      id: 2,
      name: "Ahmed",
      avatar: 'assets/images/avatar2.jpg',
      userName: "ahmed",
      points: 780,
      joinedCommunities: userJoinedCommunities,
      quote: quotes[_random.nextInt(quotes.length)],
      totalJoinedCommunities: jCL,
      totalPostUpvotes: _random.nextInt(2533),
      totalCommentUpvotes: _random.nextInt(2533),
      interests: ['Mobile Apps', 'Flutter', 'Dart', 'UI/UX', 'Firebase'],
    ),
    Author(
      id: 3,
      name: "Mohamed",
      avatar: 'assets/images/avatar3.jpg',
      userName: "mohamed",
      points: 620,
      joinedCommunities: userJoinedCommunities,
      quote: quotes[_random.nextInt(quotes.length)],
      totalJoinedCommunities: jCL,
      totalPostUpvotes: _random.nextInt(2533),
      totalCommentUpvotes: _random.nextInt(2533),
      interests: ['Data Science', 'Machine Learning', 'Python', 'Algorithms', 'Statistical Analysis'],
    ),
    Author(
      id: 4,
      name: "Ali",
      avatar: 'assets/images/avatar4.jpg',
      userName: "ali",
      points: 930,
      joinedCommunities: userJoinedCommunities,
      quote: quotes[_random.nextInt(quotes.length)],
      totalJoinedCommunities: jCL,
      totalPostUpvotes: _random.nextInt(2533),
      totalCommentUpvotes: _random.nextInt(2533),
      interests: ['DevOps', 'Cloud Computing', 'Docker', 'Kubernetes', 'AWS'],
    ),
    Author(
      id: 5,
      name: "Maged",
      avatar: 'assets/images/avatar5.jpg',
      userName: "maged",
      points: 540,
      joinedCommunities: userJoinedCommunities,
      quote: quotes[_random.nextInt(quotes.length)],
      totalJoinedCommunities: jCL,
      totalPostUpvotes: _random.nextInt(2533),
      totalCommentUpvotes: _random.nextInt(2533),
      interests: ['Backend', 'Java', 'Spring', 'Microservices', 'System Design'],
    ),
    Author(
      id: 6,
      name: "Aslam",
      avatar: 'assets/images/avatar6.jpg',
      userName: "aslam",
      points: 810,
      joinedCommunities: userJoinedCommunities,
      quote: quotes[_random.nextInt(quotes.length)],
      totalJoinedCommunities: jCL,
      totalPostUpvotes: _random.nextInt(2533),
      totalCommentUpvotes: _random.nextInt(2533),
      interests: ['Cybersecurity', 'Blockchain', 'Cryptography', 'Ethical Hacking', 'Network Security'],
    ),
  ];

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
          interests: getRandomInterests(),
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
