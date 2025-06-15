import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/token_storage.dart';
import '../data/models/quiz_model.dart';
import '../../../core/helpers/api_helper.dart';

class QuizService {
  final baseUrl = ApiHelper.baseUrl;

  Future<List<Quiz>> getCommunityQuizzes(int communityId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/quizzes/community/$communityId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      final List<dynamic> quizzesJson = body['data'];
      return quizzesJson.map((json) => Quiz.fromJson(json)).toList();
    } else {
      throw Exception(body['message'] ?? 'Failed to load quizzes');
    }
  }

  Future<Quiz> getQuizById(int quizId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/quizzes/$quizId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return Quiz.fromJson(body['data']);
    } else {
      throw Exception(body['message'] ?? 'Failed to load quiz');
    }
  }
} 