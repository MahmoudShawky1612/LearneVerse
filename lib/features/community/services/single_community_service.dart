import 'dart:convert';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api_helper.dart';
import '../../comments/data/models/comment_model.dart';

class SingleCommunityApiService {
  SingleCommunityApiService();

  static const String baseUrl = ApiHelper.baseUrl;

  Future<Community> fetchSingleCommunity(int communityId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/communities/$communityId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      final communityJson = json['data'] ?? json;

      return Community.fromJson(communityJson);
    } else {
      throw Exception('Failed to load community'
          ' - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}