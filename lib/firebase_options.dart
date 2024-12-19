import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not configured for this platform.',
    );
  }

  static String _getConfig(String key) {
    // Try .env file first
    final envValue = dotenv.env[key];
    if (envValue != null && envValue.isNotEmpty) {
      return envValue;
    }

    // Fall back to build-time environment variables
    switch (key) {
      case 'FIREBASE_API_KEY':
        final value = const String.fromEnvironment('FIREBASE_API_KEY');
        if (value.isNotEmpty) return value;
        break;
      case 'FIREBASE_AUTH_DOMAIN':
        final value = const String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
        if (value.isNotEmpty) return value;
        break;
      case 'FIREBASE_PROJECT_ID':
        final value = const String.fromEnvironment('FIREBASE_PROJECT_ID');
        if (value.isNotEmpty) return value;
        break;
      case 'FIREBASE_STORAGE_BUCKET':
        final value = const String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
        if (value.isNotEmpty) return value;
        break;
      case 'FIREBASE_MESSAGING_SENDER_ID':
        final value = const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
        if (value.isNotEmpty) return value;
        break;
      case 'FIREBASE_APP_ID':
        final value = const String.fromEnvironment('FIREBASE_APP_ID');
        if (value.isNotEmpty) return value;
        break;
    }
    
    throw Exception('Firebase configuration not found for: $key');
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: _getConfig('FIREBASE_API_KEY'),
    authDomain: _getConfig('FIREBASE_AUTH_DOMAIN'),
    projectId: _getConfig('FIREBASE_PROJECT_ID'),
    storageBucket: _getConfig('FIREBASE_STORAGE_BUCKET'),
    messagingSenderId: _getConfig('FIREBASE_MESSAGING_SENDER_ID'),
    appId: _getConfig('FIREBASE_APP_ID'),
  );
} 