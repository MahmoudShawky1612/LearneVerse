import 'dart:convert';
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:http/http.dart' as http;
import '../../../utils/token_storage.dart';
import '../data/models/contributions_model.dart';

class UserContributionsApiService {
  final baseUrl = ApiHelper.baseUrl;

  Future<List<UserContribution>> fetchUserContributions(int userId) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/profiles/contributions/$userId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response data: $data');
      final List<dynamic> contributionsJson =
          data['data'][0]['UserContributions']; // Adjusted for nested structure
      return contributionsJson
          .map((json) => UserContribution.fromJson(json))
          .toList();
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');
    }
  }
}
