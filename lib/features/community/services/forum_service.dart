import 'dart:convert';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:flutterwidgets/features/home/data/models/post_model.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api_helper.dart';
import '../../comments/data/models/comment_model.dart';

class ForumApiService {
  ForumApiService();
  static const String baseUrl = ApiHelper.baseUrl;

  Future<List<Post>> fetchPostsForCommunity(int forumId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/posts/forums/$forumId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body)['data'];
      return json.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts'
          ' - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}