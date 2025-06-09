import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/api_helper.dart';
import '../../../utils/token_storage.dart';
import '../../community/data/models/community_members_model.dart';
import '../../home/data/models/community_model.dart';

class SearchService {
  static const baseUrl = ApiHelper.baseUrl;

  Future<Map<String, dynamic>> search({
    required String query,
    List<String>? tagNames,
    String? type,
  }) async {
    final token = await TokenStorage.getToken();
    final queryParameters = {
      'q': query,
      if (type != null) 'type': type,
      if (tagNames != null && tagNames.isNotEmpty) 'tags': tagNames.join(','),
    };

    final response = await http.get(
      Uri.parse('$baseUrl/search').replace(queryParameters: queryParameters),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] != true) {
        throw Exception('Search failed: ${body['message']}');
      }
      final data = body['data'];
      List<Community> communities = [];
      List<CommunityMember> users = [];

      if (data['communities'] != null) {
        communities = (data['communities'] as List<dynamic>)
            .map((json) => Community.fromJson(json))
            .toList();
      }
      if (data['users'] != null) {
        users = (data['users'] as List<dynamic>)
            .map((json) => CommunityMember.fromJson(json))
            .toList();
      }
      return {'communities': communities, 'users': users};
    } else {
      throw Exception('Failed to search - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}