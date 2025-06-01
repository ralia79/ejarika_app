import 'dart:convert';
import 'package:ejarika_app/main.dart';
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
  bool errorOcc = false;

  Future<void> _loadCitiesAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final citiesJson = prefs.getString('cities_json');

    if (citiesJson != null) {
      print('داده‌های شهرها از حافظه بارگذاری شدند: $citiesJson');
      _navigateToHomeScreen();
    } else {
      try {
        List<City> cities = await adService.getCities();
        final citiesJson = cities.map((city) => city.toJson()).toList();
        await prefs.setString('cities_json', jsonEncode(citiesJson));
        print('شهرها با موفقیت دریافت و ذخیره شدند: $cities');
        _navigateToHomeScreen();
      } catch (e) {
        setState(() {
          errorOcc = true;
        });
        print('خطا در بارگذاری شهرها: $e');
      }
    }
  }

  _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationWrapper()),
    );
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
          errorOcc
              ? Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.white,
                    ),
                    onPressed: _loadCitiesAndNavigate,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: AppColors.secondary,
                        ),
                        SizedBox(width: 8),
                        Text('دوباره تلاش کنید'),
                      ],
                    ),
                  ),
                )
              : Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: BouncingDotsLoader(),
                  ),
                )
        ],
      ),
    );
  }
}
