import 'dart:convert';
import 'package:ejarika_app/main.dart';
import 'package:ejarika_app/models/city.dart';
import 'package:ejarika_app/models/user.dart';
import 'package:ejarika_app/services/adService.dart';
import 'package:ejarika_app/utils/colors.dart';
import 'package:ejarika_app/widgets/bouncingDotLoader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AdService adService = AdService();
  bool errorOcc = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _loadUserData();
    await _loadCitiesAndNavigate();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      User user = await adService.fetchAccountData();
      await prefs.setString('user_data', jsonEncode(user));
      print('user loaded successfully: $user');
    } catch (e) {
      print('failed to load user: $e');
      await prefs.remove('user_data');
      await prefs.remove('jwt_token');
    }
  }

  Future<void> _loadCitiesAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final citiesJson = prefs.getString('cities_json');

    if (citiesJson != null) {
      print('cities loaded from prefs: $citiesJson');
      _navigateToHomeScreen();
    } else {
      try {
        List<City> cities = await adService.getCities();
        final citiesJson = cities.map((city) => city.toJson()).toList();
        await prefs.setString('cities_json', jsonEncode(citiesJson));
        print('cities loaded successfully and stored: $cities');
        _navigateToHomeScreen();
      } catch (e) {
        print('failed to load cities: $e');
        if (!mounted) return;
        setState(() {
          errorOcc = true;
        });
      }
    }
  }

  void _navigateToHomeScreen() {
    if (!mounted) return;
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
                    onPressed: _initializeApp,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 8),
                        const Text('دوباره تلاش کنید'),
                      ],
                    ),
                  ),
                )
              : const Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: BouncingDotsLoader(),
                  ),
                ),
        ],
      ),
    );
  }
}
