import 'dart:convert';

import 'package:ejarika_app/models/city.dart';
import 'package:ejarika_app/models/item.dart';
import 'package:http/http.dart' as http;

class AdService {
  final String apiUrl = "https://ejarika.clipboardapp.online/api";

  Future<List<Item>> fetchItems(int cityId, String searchTerm) async {
    try {
      String url = '/advertisements?cityId=$cityId';
      if (searchTerm.length > 0) {
        url += '&query=$searchTerm';
      }
      print(url);
      final response = await http.get(Uri.parse(apiUrl + url));

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
      final response = await http.get(Uri.parse(apiUrl + '/advertisements/my'));

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

  Future<Item> findItem(itemId) async {
    try {
      final response =
          await http.get(Uri.parse(apiUrl + '/advertisements/' + itemId));

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(decodedBody) as Map<String, dynamic>;

        return Item.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load items - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }

  Future<Item> createAd(ad) async {
    try {
      final response =
          await http.post(Uri.parse(apiUrl + '/advertisements'), body: ad);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(decodedBody) as Map<String, dynamic>;

        return Item.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load items - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }

  Future<List<City>> getCities() async {
    try {
      final response = await http.get(Uri.parse(apiUrl + '/cities'));

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
