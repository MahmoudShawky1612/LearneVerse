import 'dart:convert';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../data/model/user_model.dart';

class AuthApiService {
  static const String _baseUrl = 'https://5cb0-217-55-221-35.ngrok-free.app/api/v1';

  Future<User> login({required String email, required String password}) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final accessToken = body['data']['accessToken'];
      TokenStorage.saveToken(accessToken);
      final refreshToken = body['data']['refreshToken'];

      final payload = JwtDecoder.decode(accessToken);
      return User.fromJwtPayload(payload, accessToken, refreshToken);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }
}
