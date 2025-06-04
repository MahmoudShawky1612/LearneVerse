import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/user_profile_model.dart';

class UserProfileApiService {

  static const String baseUrl = 'https://5cb0-217-55-221-35.ngrok-free.app/api/v1';

  Future<UserProfile> fetchUserProfile(int userId, String token) async {
    final url = Uri.parse('$baseUrl/profile/$userId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data['data']);
    } else {
      throw Exception('Failed to fetch user profile: ${response.statusCode}');
    }
  }
}
