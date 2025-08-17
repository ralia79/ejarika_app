import 'dart:convert';

import 'package:ejarika_app/models/city.dart';
import 'package:ejarika_app/models/item.dart';
import 'package:ejarika_app/services/api_client.dart';

class AdService {
  final String apiUrl = "https://ejarika.clipboardapp.online/api";
  final ApiClient _apiClient = ApiClient();

  Future<List<Item>> fetchItems(int cityId, String searchTerm) async {
    try {
      String url = '$apiUrl/advertisements?cityId=$cityId';
      if (searchTerm.isNotEmpty) {
        url += '&query=$searchTerm';
      }

      final response = await _apiClient.get(url);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(decodedBody);
        return data.map((item) => Item.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to load items - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }

  Future<List<Item>> fetchOwnItems() async {
    try {
      final response = await _apiClient.get('$apiUrl/advertisements/my');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(decodedBody);
        return data.map((item) => Item.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to load items - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }

  Future<Item> findItem(String itemId) async {
    try {
      final response = await _apiClient.get('$apiUrl/advertisements/$itemId');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(decodedBody) as Map<String, dynamic>;
        return Item.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load item - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load item: $e');
    }
  }

  Future<Item> createAd(Map<String, dynamic> ad) async {
    try {
      final response = await _apiClient.post('$apiUrl/advertisements', body: ad);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(decodedBody) as Map<String, dynamic>;
        return Item.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to create ad - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create ad: $e');
    }
  }

  Future<List<City>> getCities() async {
    try {
      final response = await _apiClient.get('$apiUrl/cities');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(decodedBody);
        return data.map((item) => City.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to load cities - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load cities: $e');
    }
  }
}
