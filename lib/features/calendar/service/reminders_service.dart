import 'dart:convert';
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:http/http.dart' as http;
import '../../../utils/token_storage.dart';
import '../data/models/reminder_model.dart';

class RemindersApiService {
  static const String baseUrl = ApiHelper.baseUrl;

  Future<List<Reminder>> fetchReminders() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/reminders'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = body['data'];
      return data.map((json) => Reminder.fromJson(json)).toList();
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');
    }
  }
} 