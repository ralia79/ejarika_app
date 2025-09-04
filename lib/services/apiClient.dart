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

  Future<http.Response> delete(String url, {Map<String, dynamic>? body}) async {
    final headers = await _buildHeaders();
    return _client.delete(Uri.parse(url),
        headers: headers, body: jsonEncode(body));
  }

  Future<Map<String, String>> _buildHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('jwt_token');
    final token =
        "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ1c2VyMSIsImF1dGgiOiJST0xFX1VTRVIiLCJleHAiOjE3NTgwMzIyNjB9.K4N5-__HRHHfrj2NYrodo3eZsPfC0gxSjgHGa75-Tq2gmwFFmZx1Hjw9EjEz8n7UnM4ncAdsKWoPmelb_8b9_g";
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
