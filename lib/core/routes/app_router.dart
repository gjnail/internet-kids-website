import 'package:flutter/material.dart';
import 'package:internet_kids_website/features/distortion/presentation/pages/distortion_page.dart';
import 'package:internet_kids_website/features/home/presentation/pages/home_page.dart';
import 'package:internet_kids_website/features/success/presentation/pages/success_page.dart';

class AppRouter {
  static const String home = '/';
  static const String distortion = '/distortion';
  static const String success = '/success';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case distortion:
        return MaterialPageRoute(builder: (_) => const DistortionPage());
      case success:
        return MaterialPageRoute(builder: (_) => const SuccessPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
} 