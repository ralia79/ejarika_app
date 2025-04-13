import 'package:Ejarika/view/chatsScreen.dart';
import 'package:Ejarika/view/homeScreen.dart';
import 'package:Ejarika/view/newAdScreen.dart';
import 'package:Ejarika/view/profileScreen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/';
  static const String createAd = '/create-ad';
  static const String chats = '/chats';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case createAd:
        return MaterialPageRoute(builder: (_) => NewAdScreen());
      case chats:
        return MaterialPageRoute(builder: (_) => ChatsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => Profilescreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
