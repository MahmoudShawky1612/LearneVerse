class User {
  final int id;
  final String fullname;
  final String username;
  final String email;
  final String accessToken;
  final String refreshToken;

  User({
    required this.id,
    required this.fullname,
    required this.username,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
  });

  factory User.fromJwtPayload(
      Map<String, dynamic> payload, String accessToken, String refreshToken) {
    return User(
      id: payload['id'],
      fullname: payload['fullname'],
      username: payload['username'],
      email: payload['email'],
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
