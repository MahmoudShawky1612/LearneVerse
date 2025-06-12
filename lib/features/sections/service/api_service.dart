import 'dart:convert';
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import '../data/models/models.dart';

class SectionsApiService {
  final String baseUrl = ApiHelper.baseUrl;

  static Future<List<SectionModel>> fetchSections(int classroomId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('${ApiHelper.baseUrl}/sections/classrooms/$classroomId'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((e) => SectionModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load sections');
    }
  }

  static Future<List<LessonContent>> fetchLessons(int sectionId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('${ApiHelper.baseUrl}/lessons/sections/$sectionId'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((e) => LessonContent.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }

  static Future<bool> toggleLessonCompleted(int lessonId) async {
    final token = await TokenStorage.getToken();
    final response = await http.patch(
      Uri.parse('${ApiHelper.baseUrl}/lessons/$lessonId/toggle-completed'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']['isCompleted'] as bool;
    } else {
      throw Exception('Failed to toggle lesson completion');
    }
  }
}
