class Author {
  final int id;
  final String name;
  final String avatar;

  Author({required this.id, required this.name, required this.avatar});

  static List<Author> generateDummyAuthors() {
    return [
      Author(id: 1, name: "Hassan", avatar: 'assets/images/avatar1.jpg'),
      Author(id: 2, name: "Ahmed", avatar: 'assets/images/avatar2.jpg'),
      Author(id: 3, name: "Mohamed", avatar: 'assets/images/avatar3.jpg'),
      Author(id: 4, name: "Ali", avatar: 'assets/images/avatar4.jpg'),
      Author(id: 5, name: "Maged", avatar: 'assets/images/avatar5.jpg'),
      Author(id: 6, name: "Aslam", avatar: 'assets/images/avatar6.jpg'),
    ];
  }
}