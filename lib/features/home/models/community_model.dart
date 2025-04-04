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
  });

  static List<Community> communities = [
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
    Community(
        id: 5,
        image: 'assets/images/nodejs.jpg',
        name: "NodeJs",
        memberCount: 60,
        tags: ['advanced', 'node.js'],
        communityPrivacy: 'Private',
        communityBackgroundImage: 'assets/images/nodejs1.jpg',
        rating: 4.3,
        reviews: 75),
    Community(
        id: 6,
        image: 'assets/images/post.jpg',
        name: "Postgres",
        memberCount: 2042,
        tags: ['popular', 'database'],
        communityPrivacy: 'Private',
        communityBackgroundImage: 'assets/images/post1.jpg',
        rating: 4.8,
        reviews: 250),
    Community(
        id: 7,
        image: 'assets/images/react.jpg',
        name: "React",
        memberCount: 700,
        tags: ['react'],
        communityPrivacy: 'Public',
        communityBackgroundImage: 'assets/images/react1.jpg',
        rating: 3.1,
        reviews: 300),
    Community(
        id: 8,
        image: 'assets/images/ts.jpg',
        name: "TypeScript",
        memberCount: 21,
        tags: ['typescript'],
        communityPrivacy: 'Public',
        communityBackgroundImage: 'assets/images/ts1.jpg',
        rating: 4.4,
        reviews: 80),
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
