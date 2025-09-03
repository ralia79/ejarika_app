import 'dart:async';
import 'dart:convert';
import 'package:ejarika_app/models/city.dart';
import 'package:ejarika_app/models/item.dart';
import 'package:ejarika_app/services/adService.dart';
import 'package:ejarika_app/utils/colors.dart';
import 'package:ejarika_app/widgets/itemCard.dart';
import 'package:ejarika_app/widgets/searchHeader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> filteredItems = [];
  List<Item> allItems = [];
  int selectedCity = 1;
  List<City> cities = [];
  final AdService adService = AdService();
  bool fetchingData = true;
  bool hasError = false;
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _setupScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCityId = prefs.getInt('selected_city_id');
    setState(() {
      selectedCity = savedCityId ?? 1;
    });

    final citiesJson = prefs.getString('cities_json');
    if (citiesJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(citiesJson);
        setState(() {
          cities = decoded.map((json) => City.fromJson(json)).toList();
        });
      } catch (e) {
        print('خطا در بارگذاری شهرها از حافظه: $e');
      }
    }
    await _loadItems();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        _loadItems();
      }
    });
  }

  Future<void> _loadItems() async {
    setState(() {
      fetchingData = true;
    });
    try {
      List<Item> items = await adService.fetchItems(selectedCity, searchTerm);
      setState(() {
        allItems = items;
        filteredItems = items;
        hasError = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
      });
      print('Failed to load items: $e');
    } finally {
      setState(() {
        fetchingData = false;
      });
    }
  }

  void _filterItems(String query) {
    searchTerm = query;
    _loadItems();
  }

  void _onSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterItems(query);
    });
  }

  void _changeCity(int? cityId) async {
    if (cityId != null) {
      setState(() {
        selectedCity = cityId;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('selected_city_id', cityId);
      await _loadItems();
    }
  }

  String _getCityName(int cityId) {
    final city = cities.firstWhere(
          (city) => city.id == cityId,
      orElse: () => City(id: 1, name: 'Unknown', latitude: 0, longitude: 0),
    );
    return city.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          title: SearchHeader(
            onSearch: _onSearch, // Use debounced search handler
            selectedCity: selectedCity,
            onCityChanged: _changeCity,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            if (fetchingData && !hasError)
              SizedBox(
                child: CircularProgressIndicator(
                  color: AppColors.secondary,
                  strokeWidth: 1,
                ),
                height: 20,
                width: 20,
              ),
            if (hasError)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('خطایی پیش آمده است !'),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: _loadItems,
                      child: fetchingData
                          ? const SizedBox(
                        child: CircularProgressIndicator(strokeWidth: 1),
                        height: 10,
                        width: 10,
                      )
                          : const Text('دوباره تلاش کنید'),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadItems,
                color: AppColors.primary,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredItems.length,
                  itemBuilder: (ctx, index) {
                    final item = filteredItems[index];
                    return ItemCard(item: item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}