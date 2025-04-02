class Community {
  final int id;
  final String name;
  final String image;
  final int memberCount;

  Community({required this.id, required this.name, required this.image,required this.memberCount});

  static List<Community> generateDummyCommunities() {
    return [
      Community(id: 1, image: 'assets/images/angular.jpg', name: "Angular", memberCount:328),
      Community(id: 2, image: 'assets/images/c.jpg', name: "C", memberCount:245),
      Community(id: 3, image: 'assets/images/go.jpg', name: "Go Lang", memberCount:356),
      Community(id: 4, image: 'assets/images/js.jpg', name: "JavaScript", memberCount:134),
      Community(id: 5, image: 'assets/images/nodejs.jpg', name: "NodeJs", memberCount:32),
      Community(id: 6, image: 'assets/images/post.jpg', name: "Postgres", memberCount:2042),
      Community(id: 7, image: 'assets/images/react.jpg', name: "React", memberCount:612),
      Community(id: 8, image: 'assets/images/ts.jpg', name: "TypeScript", memberCount:21),
    ];
  }
}