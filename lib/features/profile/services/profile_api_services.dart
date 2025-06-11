import 'dart:convert';
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:http/http.dart' as http;
import '../../../utils/token_storage.dart';
import '../data/models/user_profile_model.dart';

class UserProfileApiService {
  final baseUrl = ApiHelper.baseUrl;

  Future<UserProfile> fetchUserProfile(int userId) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/profiles/$userId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 404) {
      final data = jsonDecode(response.body);
      print('Response data: $data');
      return UserProfile.fromJson(data['data']);
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');
    }
  }

}