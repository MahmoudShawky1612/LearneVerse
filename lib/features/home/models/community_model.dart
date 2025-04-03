class Community {
  final int id;
  final String name;
  final String image;
  final int memberCount;
  final List<String> tags;

  Community(
      {required this.id,
      required this.name,
      required this.image,
      required this.memberCount,
      required this.tags});

  static List<Community> communities = [
    Community(
        id: 1,
        image: 'assets/images/angular.jpg',
        name: "Angular",
        memberCount: 328,
        tags: ['angular', 'advanced']),
    Community(
        id: 2,
        image: 'assets/images/c.jpg',
        name: "C",
        memberCount: 245,
        tags: ['beginner', 'c']),
    Community(
        id: 2,
        image: 'assets/images/c.jpg',
        name: "C",
        memberCount: 245,
        tags: ['advanced']),
    Community(
        id: 3,
        image: 'assets/images/go.jpg',
        name: "Go Lang",
        memberCount: 356,
        tags: ['beginner', 'go lang']),
    Community(
        id: 4,
        image: 'assets/images/js.jpg',
        name: "JavaScript",
        memberCount: 134,
        tags: ['problem solving']),
    Community(
        id: 5,
        image: 'assets/images/nodejs.jpg',
        name: "NodeJs",
        memberCount: 32,
        tags: ['intermediate', 'node.js']),
    Community(
        id: 5,
        image: 'assets/images/nodejs.jpg',
        name: "NodeJs",
        memberCount: 32,
        tags: ['advanced', 'node.js']),
    Community(
        id: 6,
        image: 'assets/images/post.jpg',
        name: "Postgres",
        memberCount: 2042,
        tags: ['popular' 'database']),
    Community(
        id: 6,
        image: 'assets/images/post.jpg',
        name: "Postgres",
        memberCount: 2042,
        tags: ['database']),
    Community(
        id: 7,
        image: 'assets/images/react.jpg',
        name: "React",
        memberCount: 612,
        tags: ['react', 'new']),
    Community(
        id: 7,
        image: 'assets/images/react.jpg',
        name: "React",
        memberCount: 612,
        tags: [
          'react',
        ]),
    Community(
        id: 8,
        image: 'assets/images/ts.jpg',
        name: "TypeScript",
        memberCount: 21,
        tags: ['typescript']),
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

  static List<Community> searchUsers(String communityName) {
    List<Community> foundCommunities = [];
    for (int i = 0; i < communities.length; i++) {
      if (communities[i].name.toLowerCase() == communityName.toLowerCase()) {
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
