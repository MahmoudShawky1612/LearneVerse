import 'dart:convert';
import 'dart:io';
import 'package:flutterwidgets/features/home/data/models/post_model.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../../../utils/api_helper.dart';
import '../data/models/forum_post_mdel.dart';

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
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body)['data'];
      return json.map((post) => Post.fromJson(post)).toList();
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');

    }
  }

  Future<ForumPost> createPost(int forumId, String title, String content, List<String> attachments) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/posts/forums/$forumId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'attachments': attachments,
      }),
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      if (json['data'] == null) {
        throw Exception('Response data is null');
      }
      return ForumPost.fromJson(json['data']);
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');
    }
  }

  Future<String> uploadImage(File image) async {
    final token = await TokenStorage.getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload/file'),
    );

    final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
        contentType: MediaType.parse(mimeType),
      ),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print('Upload Image Response: ${response.statusCode} - $responseBody'); // Debug log
    if (response.statusCode == 201) {
      final json = jsonDecode(responseBody);
      if (json['fileUrl'] == null) {
        throw Exception('No file URL returned');
      }
      return json['fileUrl'];
    } else {
      throw Exception('Failed to upload image - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}