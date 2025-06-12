import 'dart:convert';
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = ApiHelper.baseUrl;

  Future<String?> getUserRoleInCommunity(int communityId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/communities/$communityId/user-role-in-a-community'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] as String?;
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');
    }
  }

  Future<bool> createJoinRequest(int communityId) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/communities/$communityId/join-requests'),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 400) {
      final data = jsonDecode(response.body);
      return data['message'] == 'Joined community successfully';
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchJoinRequests(int communityId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/communities/$communityId/join-requests'),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = body['data'] as List;
      return data.cast<Map<String, dynamic>>();
    } else {
      return Future.error(body['message'] ?? 'Unknown error');
    }
  }

  Future<bool> updateJoinRequestStatus(int requestId, String status) async {
    final token = await TokenStorage.getToken();
    final url =
        Uri.parse('$baseUrl/communities/join-requests/status/$requestId');
    final response = await http.patch(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          body['message'] ?? 'Failed to update join request status');
    }
  }
}
