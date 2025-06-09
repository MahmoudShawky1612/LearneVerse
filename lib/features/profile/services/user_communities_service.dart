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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Communities response data: $data');
      // Extract the 'Community' object from each item in the 'data' list
      return (data['data'] as List)
          .map((json) => Community.fromJson(json['Community']))
          .toList();
    } else {
      print('Failed to fetch communities: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to fetch communities: ${response.statusCode}');
    }
  }
}