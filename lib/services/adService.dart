import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ejarika_app/models/category.dart';
import 'package:ejarika_app/models/chat.dart';
import 'package:ejarika_app/models/city.dart';
import 'package:ejarika_app/models/item.dart';
import 'package:ejarika_app/models/message.dart';
import 'package:ejarika_app/models/user.dart';
import 'package:ejarika_app/services/apiClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdService {
  final String apiUrl = "https://ejarika.ir/api";
  final ApiClient _apiClient = ApiClient();

  Future<Object> loginRequest(String phone) async {
    Map<String, dynamic> phoneObject = {"username": phone};
    try {
      final response = await _apiClient.post(
        '$apiUrl/loginRequest',
        body: phoneObject,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to login request - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to login request: $e');
    }
  }

  Future<Object> confirmLogin(String phone, String code) async {
    Map<String, dynamic> phoneObject = {"username": phone, "password": code};
    try {
      final response = await _apiClient.post(
        '$apiUrl/authenticate',
        body: phoneObject,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception(
            'Failed to login request - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to login request: $e');
    }
  }

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

  Future<List<Item>> fetchOwnFavItems() async {
    try {
      final response = await _apiClient.get('$apiUrl/favorites');

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

  Future<List<Chat>> fetchOwnChats() async {
    try {
      final response = await _apiClient.get('$apiUrl/chats');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(decodedBody);
        return data.map((item) => Chat.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to load chats - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load chats: $e');
    }
  }

  Future<Chat> fetchChatById(int chatId) async {
    try {
      final response = await _apiClient.get('$apiUrl/chats/$chatId');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(decodedBody);
        return Chat.fromJson(data);
      } else {
        throw Exception(
            'Failed to load chat - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load chat: $e');
    }
  }

  Future<Chat> createNewChat(Chat chat) async {
    try {
      final response =
          await _apiClient.post('$apiUrl/chats', body: chat.toJson());

      if (response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(decodedBody);
        return Chat.fromJson(data);
      } else {
        throw Exception(
            'Failed to load items - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }

  Future<Item> createNewAdvertisement(FormData advertisement) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final Dio _dio = Dio();

      final response = await _dio.post(
        '$apiUrl/advertisements',
        data: advertisement,
        options: Options(
          headers: {
            "Authorization": token != null ? "Bearer $token" : "",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 201) {
        final decodedBody = jsonDecode(jsonEncode(response.data));
        return Item.fromJson(decodedBody);
      } else {
        throw Exception(
            'Failed to load items - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }

  Future<Message> createNewMessage(Message message) async {
    try {
      final response =
          await _apiClient.post('$apiUrl/messages', body: message.toJson());

      if (response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(decodedBody);
        return Message.fromJson(data);
      } else {
        throw Exception(
            'Failed to create messages - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create messages: $e');
    }
  }

  Future<User> fetchAccountData() async {
    try {
      final response = await _apiClient.get('$apiUrl/account');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);

        final Map<String, dynamic> data = json.decode(decodedBody);
        return User.fromJson(data);
      } else {
        throw Exception(
            'Failed to load user data - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user data: $e');
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
      final response =
          await _apiClient.post('$apiUrl/advertisements', body: ad);

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

  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiClient.get('$apiUrl/categories');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(decodedBody);
        return data.map((item) => Category.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to load categories - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<Object> makeFavorite(User user, Item item) async {
    try {
      final response = await _apiClient.post('$apiUrl/favorites', body: {
        "advertisement": item.toJson(),
        "user": user.toJson(),
      });

      if (response.statusCode == 201) {
        print(response);
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(decodedBody) as Map<String, dynamic>;
        return jsonData;
      } else {
        throw Exception(
            'Failed to make fav - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to make fav: $e');
    }
  }

  Future<Object> removeFromFavorite(User user, Item item) async {
    try {
      final response =
          await _apiClient.delete('$apiUrl/favorites/${user.id}/${item.id}');

      if (response.statusCode == 204) {
        return new Object();
      } else {
        throw Exception(
            'Failed to remove fav - status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to remove fav: $e');
    }
  }
}
