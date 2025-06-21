import 'dart:convert';
import 'package:flutterwidgets/core/helpers/api_helper.dart';
import 'package:flutterwidgets/core/helpers/url_helper.dart';
import 'package:http/http.dart' as http;
import '../../../utils/token_storage.dart';
import '../data/models/quiz_model.dart';

class QuizService {
  static final String baseUrl = ApiHelper.baseUrl;

  Future<List<Quiz>> getCommunityQuizzes(int communityId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('https://bb37-217-55-63-153.ngrok-free.app/api/v1/quizzes/community/$communityId'),
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
      Uri.parse('https://bb37-217-55-63-153.ngrok-free.app/api/v1/quizzes/$quizId'),
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

  Future<void> submitQuiz(int quizId, DateTime startDate, DateTime endDate, int score) async {
    final token = await TokenStorage.getToken();
    
    // Try ISO8601 format without timezone indicator
    String formatDate(DateTime date) {
      return date.toIso8601String().replaceAll('Z', '');
    }
    
    final requestBody = {
      'startDate': formatDate(startDate),
      'endDate': formatDate(endDate),
      'score': score,
    };
    

    final response = await http.post(
      Uri.parse('https://bb37-217-55-63-153.ngrok-free.app/api/v1/quizzes/$quizId/submit-quiz'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );
    
    final body = jsonDecode(response.body);

    if (response.statusCode != 200 || body['success'] != true) {
       throw Exception(body['message'] ?? 'Failed to submit quiz');
    }
  }
} 