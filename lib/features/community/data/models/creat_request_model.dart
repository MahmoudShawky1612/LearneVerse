// create_request_model.dart

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
