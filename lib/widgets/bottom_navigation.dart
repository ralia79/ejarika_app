import 'package:ejarika_app/utils/colors.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const BottomNavigation({
    Key? key,
    required this.onTabSelected,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'آگهی ها',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'آگهی جدید',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_rounded),
          label: 'گفتگو ها',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'اجاریکا من',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTabSelected,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
