import 'dart:convert';
import 'package:flutterwidgets/features/home/data/models/post_model.dart';
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:http/http.dart' as http;

class EditDeletePostApiService {
  final baseUrl = ApiHelper.baseUrl;

  Future<void> deletePost(int id) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': '*/*',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete post: ${response.statusCode}');
    }
  }

  Future<Post> editPost(int id, Map<String, dynamic> updatedData) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: json.encode(updatedData),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = body['data'];
      return Post.fromJson(data);
    } else {
      throw Exception(body['message'] ?? 'Failed to update post');
    }
  }
}