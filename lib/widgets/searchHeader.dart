import 'dart:convert';
import 'package:ejarika_app/models/city.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHeader extends StatelessWidget {
  final Function(String) onSearch;
  final int selectedCity; // Changed to int to store city id
  final Function(int?) onCityChanged; // Changed to int? to pass city id

  const SearchHeader({
    Key? key,
    required this.onSearch,
    required this.selectedCity,
    required this.onCityChanged,
  }) : super(key: key);

  Future<List<City>> _loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    final citiesJson = prefs.getString('cities_json');
    if (citiesJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(citiesJson);
        return decoded.map((json) => City.fromJson(json)).toList();
      } catch (e) {
        print('خطا در بارگذاری شهرها از حافظه: $e');
        return [];
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<City>>(
      future: _loadCities(),
      builder: (context, snapshot) {
        List<City> cities = snapshot.hasData ? snapshot.data! : [];

        return Padding(
          padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: TextField(
                      onChanged: onSearch,
                      decoration: const InputDecoration(
                        hintText: 'جستجو در همه آگهی‌ها',
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 10),
                  child: DropdownButton<int>(
                    value: cities.any((city) => city.id == selectedCity)
                        ? selectedCity
                        : null,
                    underline: const SizedBox(),
                    items: cities.map((City city) {
                      return DropdownMenuItem<int>(
                        value: city.id,
                        child: Text(city.name),
                      );
                    }).toList(),
                    onChanged: onCityChanged,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}