import 'dart:convert';
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final baseUrl = ApiHelper.baseUrl;

  Future<String?> getUserRoleInCommunity(int communityId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/communities/$communityId/user-role-in-a-community'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] as String?;
    } else {
      throw Exception('Failed to fetch user role: ${response.statusCode}');
    }
  }
}