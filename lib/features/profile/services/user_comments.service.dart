import 'dart:convert'; import 'package:flutterwidgets/utils/api_helper.dart'; import 'package:http/http.dart' as http; import 'package:flutterwidgets/utils/token_storage.dart'; import 'package:flutterwidgets/features/comments/data/models/comment_model.dart';

class UserCommentsApiService {
  final baseUrl = ApiHelper.baseUrl;

Future<List<Comment>> fetchCommentsByUser(int userId) async { final token = await TokenStorage.getToken(); final url = Uri.parse('$baseUrl/comments/user/$userId');

final response = await http.get(
  url,
  headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
);
final body = jsonDecode(response.body);

if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  return (data['data'] as List).map((json) => Comment.fromJson(json)).toList();
} else {
  return Future.error('${body['message'] ?? 'Unknown error'}');
}

} }