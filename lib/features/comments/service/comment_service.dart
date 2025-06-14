import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/api_helper.dart';
import '../../../utils/token_storage.dart';
import '../data/models/comment_model.dart';

class CommentService {
  static const String baseUrl = ApiHelper.baseUrl;

  Future<Comment> createComment({
    required String content,
    required int postId,
    int? parentId,
  }) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/comments/$postId');

    final body = {
      'content': content,
      if (parentId != null) 'parentId': parentId,
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    final jsonBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
      final jsonBody = json.decode(response.body);
      final commentJson = jsonBody['data'];
      return Comment.fromJson(commentJson);
    } else {
      return Future.error('${jsonBody['message'] ?? 'Unknown error'}');
    }
  }

  Future<List<Comment>> getComments({required int postId}) async {
    final url = Uri.parse('$baseUrl/comments/$postId');
    final token = await TokenStorage.getToken();
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> commentsJson = jsonBody['data'];
      return commentsJson.map((json) => Comment.fromJson(json)).toList();
    } else {
      return Future.error('${jsonBody['message'] ?? 'Unknown error'}');
    }
  }

  Future<void> upVoteComment(Comment comment) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/comments/upvote/${comment.id}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      comment.voteCounter = jsonBody['data']['voteCount'];
      comment.voteType = jsonBody['data']['vote']['type'];
      print('upvote successful: ${comment.voteCounter}');
      print(comment.voteType);
    } else {
      return Future.error('${jsonBody['message'] ?? 'Unknown error'}');
    }
  }

  Future<void> downVoteComment(Comment comment) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/comments/downvote/${comment.id}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      comment.voteCounter = jsonBody['data']['voteCount'];
      comment.voteType = jsonBody['data']['vote']['type'];
      print('Downvote successful: ${comment.voteCounter}');
      print(comment.voteType);
    } else {
      return Future.error('${jsonBody['message'] ?? 'Unknown error'}');
    }
  }

  Future<List<Comment>> getCommentChildren(int commentId) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/comments/get-children/$commentId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> commentsJson = jsonBody['data'];
      return commentsJson.map((json) => Comment.fromJson(json)).toList();
    } else {
      return Future.error('${jsonBody['message'] ?? 'Unknown error'}');
    }
  }
}
