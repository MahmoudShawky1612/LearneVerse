import 'dart:convert';

import 'package:flutterwidgets/features/community/data/models/creat_request_model.dart';
import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // Add logger dependency

import '../../../utils/token_storage.dart';

class JoinRequestsService {
  final String baseUrl;
  final Logger _logger = Logger(); // Initialize logger

  JoinRequestsService({String? baseUrl}) : baseUrl = baseUrl ?? ApiHelper.baseUrl;

  Future<CreateRequestResponse> createJoinRequest(int communityId) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      _logger.e('No authentication token found');
      throw Exception('Authentication token is missing. Please log in.');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/communities/$communityId/join-requests'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30)); // Add timeout

      _logger.i('Join request response: ${response.statusCode} - ${response.body}');

      Map<String, dynamic>? json;
      try {
        json = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        _logger.e('Failed to parse JSON response: $e');
        throw Exception('Invalid server response format');
      }

      if (response.statusCode == 201 || response.statusCode == 400) {
        if (json['message'] == null) {
          _logger.e('Response missing message field: $json');
          throw Exception('Invalid server response: missing message');
        }
        return CreateRequestResponse.fromJson(json);
      }

      else {
        throw Exception(
          'Failed to create join request - ${response.statusCode}: ${json['message'] ?? response.reasonPhrase}',
        );
      }
    } catch (e) {
      _logger.e('Error creating join request: $e');
      rethrow; // Rethrow to be caught by the cubit
    }
  }
}