import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/token_storage.dart';
import '../data/models/post_model.dart';

class FeedPostsApiService {
  static const String baseUrl = 'https://676c-154-236-5-88.ngrok-free.app/api/v1';

  Future<List<Post>> fetchMyFeedPosts() async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/posts/me/feed');
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> postsJson = jsonData['data'];
      return postsJson.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  Future<Map<String, dynamic>> upVotePost(int id) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/posts/upvote/$id');
    final response = await http.put(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = jsonData['data'];
      return {
        'voteCount': data['voteCount'],
        'type': data['vote']['type'],
      };
    } else {
      throw Exception('Failed to upvote post ${jsonData['message']}');
    }
  }

  Future<Map<String, dynamic>> downVotePost(int id) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/posts/downvote/$id');
    final response = await http.put(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = jsonData['data'];
      return {
        'voteCount': data['voteCount'],
        'type': data['vote']['type'],
      };
    } else {
      throw Exception('Failed to downvote post ${jsonData['message']}');
    }
  }
}
