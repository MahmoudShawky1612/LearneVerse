import 'dart:convert';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../utils/api_helper.dart';
import '../data/model/user_model.dart';

class AuthApiService {
  static const String baseUrl = ApiHelper.baseUrl;

  Future<User> login({required String email, required String password}) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final accessToken = body['data']['accessToken'];
      TokenStorage.saveToken(accessToken);
      final refreshToken = body['data']['refreshToken'];

      final payload = JwtDecoder.decode(accessToken);
      return User.fromJwtPayload(payload, accessToken, refreshToken);
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');
    }
  }
}
