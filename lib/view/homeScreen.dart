import 'package:Ejarika/utils/colors.dart';
import 'package:flutter/material.dart';
import '../models/item.dart';

class HomeScreen extends StatelessWidget {
  final List<Item> items = [
    Item(
        id: '1',
        name: 'میکروفون',
        description: 'میکروفون با کیفیت برای ضبط صدا'),
    Item(
        id: '2',
        name: 'دوربین',
        description: 'دوربین حرفه‌ای برای فیلمبرداری'),
    Item(
        id: '3',
        name: 'لپ‌تاپ',
        description: 'لپ‌تاپ با عملکرد بالا'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اجاریکا', style: TextStyle(color: AppColors.white),),
        backgroundColor: AppColors.primary,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {},
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                title: Text(item.name),
                subtitle: Text(item.description),
              ),
            ),
          );
        },
      ),
    );
  }
}
