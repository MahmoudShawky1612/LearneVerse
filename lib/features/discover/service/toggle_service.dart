import 'package:http/http.dart' as http;
import '../../../utils/api_helper.dart';
import '../../../utils/token_storage.dart';

class ToggleService {
  static const baseUrl = ApiHelper.baseUrl;

  Future<void> toggleFavoriteCommunity(int communityId) async {
    final token = await TokenStorage.getToken();
    final uri = Uri.parse('$baseUrl/favorites/$communityId/toggle');

    final response = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to toggle favorite community - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}
