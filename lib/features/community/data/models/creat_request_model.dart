
class CreateRequestModel {
  final int id;
  final int userId;
  final int communityId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CreateRequestModel({
    required this.id,
    required this.userId,
    required this.communityId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreateRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateRequestModel(
      id: json['id'],
      userId: json['userId'],
      communityId: json['communityId'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class CreateRequestResponse {
  final String message;
  final CreateRequestModel? data;

  CreateRequestResponse({
    required this.message,
    this.data,
  });

  factory CreateRequestResponse.fromJson(Map<String, dynamic> json) {
    return CreateRequestResponse(
      message: json['message'],
      data: json['data'] != null
          ? CreateRequestModel.fromJson(json['data'])
          : null,
    );
  }
}

class JoinRequestUser {
  final int id;
  final String username;
  final String fullname;
  final String email;
  final String profilePictureURL;

  JoinRequestUser({
    required this.id,
    required this.username,
    required this.fullname,
    required this.email,
    required this.profilePictureURL,
  });

  factory JoinRequestUser.fromJson(Map<String, dynamic> json) {
    return JoinRequestUser(
      id: json['id'],
      username: json['username'],
      fullname: json['fullname'],
      email: json['email'],
      profilePictureURL: json['UserProfile'] != null ? json['UserProfile']['profilePictureURL'] : '',
    );
  }
}

class JoinRequestModel {
  final int id;
  final int userId;
  final int communityId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final JoinRequestUser user;

  JoinRequestModel({
    required this.id,
    required this.userId,
    required this.communityId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) {
    return JoinRequestModel(
      id: json['id'],
      userId: json['userId'],
      communityId: json['communityId'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: JoinRequestUser.fromJson(json['User']),
    );
  }
}
