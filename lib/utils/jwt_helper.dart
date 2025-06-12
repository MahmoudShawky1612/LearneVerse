import 'package:jwt_decoder/jwt_decoder.dart';

int getUserIdFromToken(String token) {
  final payload = JwtDecoder.decode(token);
  return payload['id'] as int;
}

String getUsernameFromToken(String token) {
  final payload = JwtDecoder.decode(token);
  return payload['username'] as String;
}

String getFullNameFromToken(String token) {
  final payload = JwtDecoder.decode(token);
  return payload['fullname'] as String;
}

String getUserProfilePictureURLFromToken(String token) {
  final payload = JwtDecoder.decode(token);
  return payload['profilePictureURL'] ?? '';
}
