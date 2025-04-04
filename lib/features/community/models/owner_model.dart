import 'dart:math';

class Owner {
  final int id;
  final String userName;
  final String name;
  final String avatar;
  final String role;

  Owner(
      {required this.id,
      required this.userName,
      required this.name,
      required this.avatar,
      this.role = "Owner"});

  static List<Owner> owners = [
    Owner(
        id: 1,
        name: "Omar",
        avatar: 'assets/images/owner1.jpg',
        userName: "omar"),
    Owner(
        id: 2,
        name: "Khaled",
        avatar: 'assets/images/owner2.jpg',
        userName: "khaled"),
    Owner(
        id: 3,
        name: "Youssef",
        avatar: 'assets/images/owner3.jpg',
        userName: "youssef"),
    Owner(
        id: 4,
        name: "Fouad",
        avatar: 'assets/images/owner4.jpg',
        userName: "fouad"),
    Owner(
        id: 5,
        name: "Fatih",
        avatar: 'assets/images/owner5.jpg',
        userName: "fatih"),
    Owner(
        id: 6,
        name: "Tariq",
        avatar: 'assets/images/owner6.jpg',
        userName: "tariq"),
  ];

  static Owner getRandomOwner() {
    Random random = Random();
    int index = random.nextInt(owners.length);
    return owners[index];
  }

  static List<Owner> searchOwners(String userName) {
    List<Owner> foundOwners = [];
    for (int i = 0; i < owners.length; i++) {
      if (owners[i].name.toLowerCase().contains(userName.toLowerCase())) {
        foundOwners.add(owners[i]);
      }
    }
    return foundOwners;
  }
}
