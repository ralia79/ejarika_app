import 'package:ejarika_app/view/adScreen.dart';
import 'package:ejarika_app/view/authentication/otp-verification.dart';
import 'package:ejarika_app/view/authentication/sign-in.dart';
import 'package:ejarika_app/view/chat/chat_list_screen.dart';
import 'package:ejarika_app/view/homeScreen.dart';
import 'package:ejarika_app/view/newAdScreen.dart';
import 'package:ejarika_app/view/ownAdScreen.dart';
import 'package:ejarika_app/view/ownFavScreen.dart';
import 'package:ejarika_app/view/profileScreen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/';
  static const String createAd = '/create-ad';
  static const String chats = '/chats';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String ad = '/ad';
  static const String ownAd = '/own-ad';
  static const String signInPage = '/sign-in';
  static const String verify = '/verify';
  static const String favorites = '/favorites';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');

    if (uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments[0] == 'ad' && uri.pathSegments.length == 2) {
        final adId = uri.pathSegments[1];
        return MaterialPageRoute(
          builder: (_) => AdScreen(adId: adId),
        );
      } else if (uri.pathSegments[0] == 'chat' &&
          uri.pathSegments.length == 2) {
        final chatId = uri.pathSegments[1];
        return MaterialPageRoute(
          // TODO: add chat detail screen
          builder: (_) => AdScreen(adId: chatId),
        );
      }
    }

    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case createAd:
        return MaterialPageRoute(builder: (_) => NewAdScreen());
      case chats:
        return MaterialPageRoute(builder: (_) => ChatListScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => Profilescreen());
      case ownAd:
        return MaterialPageRoute(builder: (_) => OwnAdScreen());
      case signInPage:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case favorites:
        return MaterialPageRoute(builder: (_) => OwnFavScreen());
      case verify:
        final args = settings.arguments as Map<String, dynamic>?;
        final phone = args?['phone'] as String?;
        if (phone == null) {
          return MaterialPageRoute(builder: (_) => SignInScreen());
        }
        return MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(phone: phone));
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
