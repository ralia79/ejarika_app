import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final http.Client _client = http.Client();

  Future<http.Response> get(String url) async {
    final headers = await _buildHeaders();
    return _client.get(Uri.parse(url), headers: headers);
  }

  Future<http.Response> post(String url, {Map<String, dynamic>? body}) async {
    final headers = await _buildHeaders();
    return _client.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));
  }


  Future<Map<String, String>> _buildHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
