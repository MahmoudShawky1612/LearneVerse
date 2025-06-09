import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/api_helper.dart';
import '../../../utils/token_storage.dart';
import '../../community/data/models/community_members_model.dart';
import '../../home/data/models/community_model.dart';

class FavoriteService {
  static const baseUrl = ApiHelper.baseUrl;

  Future<List<Community>> fetchFavoriteCommunities() async {
    final token = await TokenStorage.getToken();
    final uri = Uri.parse('$baseUrl/favorites');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] != true) {
        throw Exception('Failed to fetch favorite communities: ${body['message']}');
      }
      return (body['data'] as List<dynamic>)
          .map((json) => Community.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch favorite communities - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}