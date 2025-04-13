import 'package:flutter/material.dart';

class SearchHeader extends StatelessWidget {
  final Function(String) onSearch;
  final String selectedCity;
  final Function(String?) onCityChanged;

  const SearchHeader({
    Key? key,
    required this.onSearch,
    required this.selectedCity,
    required this.onCityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: TextField(
                    onChanged: onSearch,
                    decoration: const InputDecoration(
                      hintText: 'جستجو در همه آگهی‌ها',
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                )),
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: DropdownButton<String>(
                  value: selectedCity,
                  underline: const SizedBox(),
                  items: ['مشهد', 'تهران', 'اصفهان'].map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: onCityChanged,
                ),
              )),
        ],
      ),
    );
  }
}
