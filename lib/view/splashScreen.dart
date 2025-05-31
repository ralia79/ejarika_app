import 'package:ejarika_app/models/city.dart';
import 'package:ejarika_app/services/ad_service.dart';
import 'package:ejarika_app/utils/colors.dart';
import 'package:ejarika_app/widgets/bouncing-dot-loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadCitiesAndNavigate();
  }

  final AdService adService = AdService();

  Future<void> _loadCitiesAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final cities = prefs.getStringList('cities');

    if (cities == null || cities.isEmpty) {
      try {
        List<City> cities = await adService.getCities();
        print(cities);
      } catch (e) {
        print('Failed to load items: $e');
      } finally {}
    } else {
      print('داده‌های شهرها از حافظه بارگذاری شدند: $cities');
    }

    await Future.delayed(const Duration(seconds: 2));
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const MainNavigationWrapper()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 200,
            ),
          ),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(child: BouncingDotsLoader()),
          ),
        ],
      ),
    );
  }
}
