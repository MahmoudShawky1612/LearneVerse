import 'dart:convert';
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:http/http.dart' as http;
import '../../../utils/token_storage.dart';
import '../data/models/post_model.dart';

class FeedPostsApiService {
  static const String baseUrl = ApiHelper.baseUrl;

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
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> postsJson = jsonData['data'];
      return postsJson.map((json) => Post.fromJson(json)).toList();
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');
    }
  }

  Future<void> upVotePost(Post post) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/posts/upvote/${post.id}');
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
      post.voteCounter = data['voteCount'];
      post.voteType = data['vote']['type'];
    } else {
      return Future.error('${jsonData['message'] ?? 'Unknown error'}');
    }
  }

  Future<void> downVotePost(Post post) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/posts/downvote/${post.id}');
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
      post.voteCounter = data['voteCount'];
      post.voteType = data['vote']['type'];
    } else {
      return Future.error('${jsonData['message'] ?? 'Unknown error'}');
    }
  }
}
