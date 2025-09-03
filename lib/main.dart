import 'package:ejarika_app/routes.dart';
import 'package:ejarika_app/view/chat/chatListScreen.dart';
import 'package:ejarika_app/view/mainScreens/homeScreen.dart';
import 'package:ejarika_app/view/mainScreens/newAdScreen.dart';
import 'package:ejarika_app/view/profileSection/profileScreen.dart';
import 'package:ejarika_app/view/splashScreen.dart';
import 'package:ejarika_app/widgets/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('fa', 'IR'),
      theme: ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: "YekanBakh",
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', 'IR'),
        Locale('en', 'US'),
      ],
      onGenerateRoute: Routes.generateRoute,
      home: const SplashScreen(),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  _MainNavigationWrapperState createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  final List<Widget> widgets = [
    HomeScreen(),
    NewAdScreen(),
    ChatListScreen(),
    ProfileScreen()
  ];

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: widgets[_selectedIndex],
        bottomNavigationBar: BottomNavigation(
          currentIndex: _selectedIndex,
          onTabSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class RoutesPage extends StatelessWidget {
  final String routeName;
  final GlobalKey<NavigatorState> navigatorKey;

  const RoutesPage({
    required this.routeName,
    required this.navigatorKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: routeName,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
