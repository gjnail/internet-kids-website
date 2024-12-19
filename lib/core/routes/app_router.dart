import 'package:flutter/material.dart';
import 'package:internet_kids_website/features/distortion/presentation/pages/distortion_page.dart';
import 'package:internet_kids_website/features/home/presentation/pages/home_page.dart';
import 'package:internet_kids_website/features/success/presentation/pages/success_distortion_page.dart';
import 'package:internet_kids_website/features/success/presentation/pages/success_reverb_page.dart';
import 'package:internet_kids_website/features/reverb/presentation/pages/reverb_page.dart';

class AppRouter {
  static const String home = '/';
  static const String distortion = '/distortion';
  static const String reverb = '/reverb';
  static const String successDistortion = '/success/distortion';
  static const String successReverb = '/success/reverb';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case distortion:
        return MaterialPageRoute(builder: (_) => const DistortionPage());
      case reverb:
        return MaterialPageRoute(builder: (_) => const ReverbPage());
      case successDistortion:
        return MaterialPageRoute(builder: (_) => const SuccessDistortionPage());
      case successReverb:
        return MaterialPageRoute(builder: (_) => const SuccessReverbPage());
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