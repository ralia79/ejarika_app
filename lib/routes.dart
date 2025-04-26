import 'package:flutter/material.dart';
import 'package:Ejarika/view/chatsScreen.dart';
import 'package:Ejarika/view/homeScreen.dart';
import 'package:Ejarika/view/newAdScreen.dart';
import 'package:Ejarika/view/profileScreen.dart';
import 'package:Ejarika/view/adScreen.dart';

class Routes {
  static const String home = '/';
  static const String createAd = '/create-ad';
  static const String chats = '/chats';
  static const String profile = '/profile';
  static const String ad = '/ad';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');

    if (uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments[0] == 'ad' && uri.pathSegments.length == 2) {
        final adId = uri.pathSegments[1];
        return MaterialPageRoute(
          builder: (_) => AdScreen(adId: adId),
        );
      }
    }

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
