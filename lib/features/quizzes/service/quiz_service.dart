import 'dart:convert';
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import '../data/models/quiz_model.dart';

class QuizService {
  static const String baseUrl = ApiHelper.baseUrl;

  Future<List<Quiz>> fetchCommunityQuizzes(int communityId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/quizzes/community/$communityId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> quizzesJson = body['data'];
      return quizzesJson.map((json) => Quiz.fromJson(json)).toList();
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');
    }
  }
} 