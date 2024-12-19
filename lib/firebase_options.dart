import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // Handle other platforms if needed
    throw UnsupportedError(
      'DefaultFirebaseOptions are not configured for this platform.',
    );
  }

  static String _getEnvOrDefault(String key, String defaultValue) {
    try {
      return dotenv.get(key, fallback: defaultValue);
    } catch (e) {
      print('Warning: Using default value for $key');
      return defaultValue;
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: _getEnvOrDefault('FIREBASE_API_KEY', 'AIzaSyBUD5pwzNg9njQWVmEB6mBTDgeO5-yOFLQ'),
    authDomain: _getEnvOrDefault('FIREBASE_AUTH_DOMAIN', 'internet-kids-plugins-site.firebaseapp.com'),
    projectId: _getEnvOrDefault('FIREBASE_PROJECT_ID', 'internet-kids-plugins-site'),
    storageBucket: _getEnvOrDefault('FIREBASE_STORAGE_BUCKET', 'internet-kids-plugins-site.firebasestorage.app'),
    messagingSenderId: _getEnvOrDefault('FIREBASE_MESSAGING_SENDER_ID', '329708958105'),
    appId: _getEnvOrDefault('FIREBASE_APP_ID', '1:329708958105:web:14ac6f9c985c1594bb2308'),
  );
} 