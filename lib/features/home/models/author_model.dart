class Author {
  final int id;
  final String userName;
  final String name;
  final String avatar;
  final String role;

  Author({
    required this.id,
    required this.name,
    required this.avatar,
    required this.userName,
    this.role = "Member",
  });

  static List<Author> users = [
    Author(
        id: 1,
        name: "Hassan",
        avatar: 'assets/images/avatar1.jpg',
        userName: "hassan"),
    Author(
        id: 2,
        name: "Ahmed",
        avatar: 'assets/images/avatar2.jpg',
        userName: "ahmed"),
    Author(
        id: 3,
        name: "Mohamed",
        avatar: 'assets/images/avatar3.jpg',
        userName: "mohamed"),
    Author(
        id: 4,
        name: "Ali",
        avatar: 'assets/images/avatar4.jpg',
        userName: "ali"),
    Author(
        id: 5,
        name: "Maged",
        avatar: 'assets/images/avatar5.jpg',
        userName: "maged"),
    Author(
        id: 6,
        name: "Aslam",
        avatar: 'assets/images/avatar6.jpg',
        userName: "aslam"),
  ];

  static List<Author> generateDummyAuthors() {
    return users;
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
