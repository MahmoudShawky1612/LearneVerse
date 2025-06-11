import 'dart:convert';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api_helper.dart';
import '../data/models/community_model.dart';

class CommunityApiService {

  CommunityApiService();

  static const String baseUrl = ApiHelper.baseUrl;

  Future<List<Community>> getCommunities() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/communities'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((item) => Community.fromJson(item)).toList();
      } else {
        return Future.error('${body['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('Error fetching communities: $e');
    }
  }


  Future<int> communityMembersCount(int communityId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/communities/$communityId/user-count'));
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['memberCount'];
    } else {
      return Future.error('${data['message'] ?? 'Unknown error'}');
    }
  }
}
