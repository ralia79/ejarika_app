import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Ejarika/models/item.dart';

class AdService {
  final String apiUrl =
      "https://ejarika.clipboardapp.online/api/advertisements";

  Future<List<Item>> fetchItems() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Item.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }
}
