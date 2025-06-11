import 'dart:convert';
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:http/http.dart' as http;
import '../../../utils/token_storage.dart';
import '../../home/data/models/post_model.dart';

class UserPostApiService {
  final baseUrl = ApiHelper.baseUrl;

  Future<List<Post>> fetchPostsByUser(int userId) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/posts/user/$userId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return (data['data'] as List).map((json) => Post.fromJson(json)).toList();
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');
    }
  }
}
