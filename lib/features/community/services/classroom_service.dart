import 'dart:convert';

import 'package:flutterwidgets/utils/api_helper.dart';
import 'package:http/http.dart' as http;

import '../../../utils/token_storage.dart';
import '../data/models/classroom_model.dart';

class ClassroomService {


  static const baseUrl = ApiHelper.baseUrl;

  Future<List<Classroom>> fetchClassroomsForACommunity({required int communityId}) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/classrooms/communities/$communityId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((json) => Classroom.fromJson(json)).toList();
    } else {
      return Future.error('${body['message'] ?? 'Unknown error'}');

    }
}

}