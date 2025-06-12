import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import '../../home/data/models/community_model.dart';

class UserCommunitiesApiService {
  final baseUrl = ApiHelper.baseUrl;

  Future<List<Community>> fetchCommunitiesByUser(int userId) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/users/$userId/communities');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((json) => Community.fromJson(json['Community']))
          .toList();
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');
    }
  }

  Future<String> leaveCommunity(int communityId) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/communities/$communityId/leave');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 204) {
      return 'Successfully left the community.';
    } else {
      final body = jsonDecode(response.body);
      return Future.error(body['message'] ?? 'Failed to leave community');
    }
  }
}
