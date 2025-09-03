import 'package:ejarika_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigation extends StatelessWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const BottomNavigation({
    Key? key,
    required this.onTabSelected,
    required this.currentIndex,
  }) : super(key: key);

  Future<bool> _isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    return userData != null;
  }

  void _handleTap(BuildContext context, int index) async {
    if (index == 1 || index == 2) {
      final isLoggedIn = await _isUserLoggedIn();
      if (!isLoggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('برای دسترسی به این بخش باید وارد حساب کاربری شوید'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return; 
      }
    }
    onTabSelected(index);
  }

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
      onTap: (index) => _handleTap(context, index),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
