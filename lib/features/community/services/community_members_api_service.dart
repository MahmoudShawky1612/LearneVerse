import 'dart:convert';
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import '../data/models/community_members_model.dart';

class CommunityMembersApiService {

  CommunityMembersApiService();
   final baseUrl = ApiHelper.baseUrl;
  Future<List<CommunityMember>> fetchCommunityMembers(int communityId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/communities/$communityId/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = json.decode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((json) => CommunityMember.fromJson(json)).toList();
    } else {
      print('Failed to fetch community members - ${response.statusCode}: ${response.reasonPhrase}');
      throw Exception('Failed to fetch community members - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}
