import 'package:Ejarika/models/item.dart';
import 'package:Ejarika/widgets/item_card.dart';
import 'package:Ejarika/widgets/search_header.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> allItems = [
    Item(
      id: '1',
      name: 'بخاری گازی نیک کالا',
      description: 'با گارانتی و خدمات پس از فروش',
      imageUrl: 'fill later',
      price: '8,000,000 تومان',
    ),
    Item(
      id: '2',
      name: 'اجاره ویلا (استخردار)',
      description: 'ویلا با تمام امکانات در کردان',
      imageUrl: 'fill later',
      price: '1,500,000 تومان',
    ),
    Item(
      id: '3',
      name: 'سامسونگ Galaxy J5 (2017)',
      description: 'در حد نو، با کارتن و لوازم',
      imageUrl: 'fill later',
      price: '3,000,000 تومان',
    ),
    Item(
      id: '4',
      name: 'سامسونگ Galaxy J5 (2017)',
      description: 'در حد نو، با کارتن و لوازم',
      imageUrl: 'fill later',
      price: '3,000,000 تومان',
    ),
    Item(
      id: '5',
      name: 'سامسونگ Galaxy J5 (2017)',
      description: 'در حد نو، با کارتن و لوازم',
      imageUrl: 'fill later',
      price: '3,000,000 تومان',
    ),
    Item(
      id: '6',
      name: 'سامسونگ Galaxy J5 (2017)',
      description: 'در حد نو، با کارتن و لوازم',
      imageUrl: 'fill later',
      price: '3,000,000 تومان',
    ),
    Item(
      id: '7',
      name: 'سامسونگ Galaxy J5 (2017)',
      description: 'در حد نو، با کارتن و لوازم',
      imageUrl: 'fill later',
      price: '3,000,000 تومان',
    ),
    Item(
      id: '8',
      name: 'سامسونگ Galaxy J5 (2017)',
      description: 'در حد نو، با کارتن و لوازم',
      imageUrl: 'fill later',
      price: '3,000,000 تومان',
    ),
    Item(
      id: '9',
      name: 'سامسونگ Galaxy J5 (2017)',
      description: 'در حد نو، با کارتن و لوازم',
      imageUrl: 'fill later',
      price: '3,000,000 تومان',
    ),
    Item(
      id: '10',
      name: 'سامسونگ Galaxy J5 (2017)',
      description: 'در حد نو، با کارتن و لوازم',
      imageUrl: 'fill later',
      price: '3,000,000 تومان',
    ),
  ];

  List<Item> filteredItems = [];
  String selectedCity = 'مشهد';

  @override
  void initState() {
    super.initState();
    filteredItems = allItems;
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = allItems
          .where((item) =>
              item.name.contains(query) || item.description.contains(query))
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
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            SearchHeader(
              onSearch: _filterItems,
              selectedCity: selectedCity,
              onCityChanged: _changeCity,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (ctx, index) {
                  final item = filteredItems[index];
                  return ItemCard(item: item); // استفاده از ویجت جدید
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
