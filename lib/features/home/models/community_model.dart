class Community {
  final int id;
  final String name;
  final String image;
  final int memberCount;
  final List<String> tags;
  final String communityPrivacy;
  final String communityBackgroundImage;
  final double rating;
  final int reviews;
  dynamic introVideo;

  Community({
    required this.id,
    required this.name,
    required this.image,
    required this.memberCount,
    required this.tags,
    required this.communityPrivacy,
    required this.communityBackgroundImage,
    required this.rating,
    required this.reviews,
    this.introVideo,
  });

  static List<Community> communities = [
    Community(
      id: 1,
      image: 'assets/images/angular.jpg',
      name: "Angular",
      memberCount: 328,
      tags: ['Angular', 'Web Development', 'JavaScript', 'UI/UX', 'Frontend'],
      communityPrivacy: 'Public',
      communityBackgroundImage: 'assets/images/angular1.jpg',
      rating: 4.5,
      reviews: 120,
      introVideo: 'assets/videos/angular.mp4',
    ),
    Community(
      id: 2,
      image: 'assets/images/c.jpg',
      name: "C",
      memberCount: 245,
      tags: ['C', 'Programming', 'Algorithms', 'System Design', 'Performance'],
      communityPrivacy: 'Public',
      communityBackgroundImage: 'assets/images/c1.jpg',
      rating: 2.2,
      reviews: 90,
      introVideo: 'assets/videos/c.mp4',
    ),
    Community(
      id: 3,
      image: 'assets/images/go.jpg',
      name: "Go Lang",
      memberCount: 356,
      tags: ['Go Lang', 'Programming', 'Backend', 'Cloud Computing', 'DevOps'],
      communityPrivacy: 'Public',
      communityBackgroundImage: 'assets/images/go1.jpg',
      rating: 4.6,
      reviews: 150,
      introVideo: 'assets/videos/go.mp4',
    ),
    Community(
      id: 4,
      image: 'assets/images/js.jpg',
      name: "JavaScript",
      memberCount: 134,
      tags: ['JavaScript', 'Web Development', 'React', 'Node.js', 'Frontend'],
      communityPrivacy: 'Private',
      communityBackgroundImage: 'assets/images/js1.jpg',
      rating: 4.7,
      reviews: 180,
      introVideo: 'assets/videos/js.mp4',
    ),
    Community(
      id: 5,
      image: 'assets/images/nodejs.jpg',
      name: "NodeJs",
      memberCount: 60,
      tags: ['Node.js', 'JavaScript', 'Backend', 'Web Development', 'API'],
      communityPrivacy: 'Private',
      communityBackgroundImage: 'assets/images/nodejs1.jpg',
      rating: 4.3,
      reviews: 75,
      introVideo: 'assets/videos/nodejs.mp4',
    ),
    Community(
      id: 6,
      image: 'assets/images/post.jpg',
      name: "Postgres",
      memberCount: 2042,
      tags: ['PostgreSQL', 'Database', 'Backend', 'SQL', 'Data Science'],
      communityPrivacy: 'Private',
      communityBackgroundImage: 'assets/images/post1.jpg',
      rating: 4.8,
      reviews: 250,
      introVideo: 'assets/videos/post.mp4',
    ),
    Community(
      id: 7,
      image: 'assets/images/react.jpg',
      name: "React",
      memberCount: 700,
      tags: ['React', 'JavaScript', 'Web Development', 'UI/UX', 'Frontend'],
      communityPrivacy: 'Public',
      communityBackgroundImage: 'assets/images/react1.jpg',
      rating: 3.1,
      reviews: 300,
      introVideo: 'assets/videos/react.mp4',
    ),
    Community(
      id: 8,
      image: 'assets/images/ts.jpg',
      name: "TypeScript",
      memberCount: 21,
      tags: [
        'TypeScript',
        'JavaScript',
        'Programming',
        'Web Development',
        'System Design'
      ],
      communityPrivacy: 'Public',
      communityBackgroundImage: 'assets/images/ts1.jpg',
      rating: 4.4,
      reviews: 80,
      introVideo: 'assets/videos/ts.mp4',
    ),
    Community(
      id: 9,
      image: 'assets/images/python.jpg',
      name: "Python",
      memberCount: 1500,
      tags: [
        'Python',
        'Programming',
        'Machine Learning',
        'Data Science',
        'Algorithms'
      ],
      communityPrivacy: 'Public',
      communityBackgroundImage: 'assets/images/python1.jpg',
      rating: 4.9,
      reviews: 450,
      introVideo: 'assets/videos/python.mp4',
    ),
    Community(
      id: 10,
      image: 'assets/images/flutter.jpg',
      name: "Flutter",
      memberCount: 850,
      tags: ['Flutter', 'Mobile Apps', 'Dart', 'UI/UX', 'Cross-platform'],
      communityPrivacy: 'Public',
      communityBackgroundImage: 'assets/images/flutter1.jpg',
      rating: 4.7,
      reviews: 320,
      introVideo: 'assets/videos/flutter.mp4',
    ),
  ];

  static List<Community> generateDummyCommunities() {
    return communities;
  }

  static List<Community> searchCommunities(String communityName) {
    List<Community> foundCommunities = [];
    for (int i = 0; i < communities.length; i++) {
      if (communities[i]
          .name
          .toLowerCase()
          .contains(communityName.toLowerCase())) {
        foundCommunities.add(communities[i]);
      }
    }
    return foundCommunities;
  }

  static List<Community> searchWithFilters(
      List<String> filters, String communityName) {
    List<Community> foundCommunities = searchCommunities(communityName);
    if (foundCommunities.isEmpty || filters.isEmpty) {
      return foundCommunities;
    }

    List<Community> matched = [];

    for (int i = 0; i < foundCommunities.length; i++) {
      Set<String> communityTags =
          foundCommunities[i].tags.map((tag) => tag.toLowerCase()).toSet();

      bool allFiltersMatch = filters
          .every((filter) => communityTags.contains(filter.toLowerCase()));

      if (allFiltersMatch) {
        matched.add(foundCommunities[i]);
      }
    }
    return matched;
  }
}
