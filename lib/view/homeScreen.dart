import 'package:Ejarika/services/ad_service.dart';
import 'package:Ejarika/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:Ejarika/models/item.dart';
import 'package:Ejarika/widgets/item_card.dart';
import 'package:Ejarika/widgets/search_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> filteredItems = [];
  List<Item> allItems = [];
  String selectedCity = 'مشهد';
  final AdService adService = AdService();
  bool fetchingData = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      fetchingData = true;
    });
    try {
      List<Item> items = await adService.fetchItems();
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
    setState(() {
      filteredItems = allItems
          .where((item) =>
              item.title.contains(query) || item.description.contains(query))
          .toList();
    });
  }

  void _changeCity(String? city) {
    if (city != null) {
      setState(() {
        selectedCity = city;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
            backgroundColor: AppColors.primary,
            title: Expanded(
              child: SearchHeader(
                onSearch: _filterItems,
                selectedCity: selectedCity,
                onCityChanged: _changeCity,
              ),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            if (hasError)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('خطایی پیش آمده است !'),
                    SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onPressed: _loadItems,
                        child: fetchingData
                            ? SizedBox(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                ),
                                height: 10,
                                width: 10,
                              )
                            : Text('دوباره تلاش کنید'))
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (ctx, index) {
                  final item = filteredItems[index];
                  return ItemCard(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
