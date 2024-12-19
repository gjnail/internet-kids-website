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

  static String _getRequiredEnvVar(String key) {
    try {
      final value = dotenv.env[key];
      if (value == null || value.isEmpty) {
        throw Exception('Required environment variable $key is not set');
      }
      return value;
    } catch (e) {
      throw Exception('Failed to load required environment variable $key: $e');
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: _getRequiredEnvVar('FIREBASE_API_KEY'),
    authDomain: _getRequiredEnvVar('FIREBASE_AUTH_DOMAIN'),
    projectId: _getRequiredEnvVar('FIREBASE_PROJECT_ID'),
    storageBucket: _getRequiredEnvVar('FIREBASE_STORAGE_BUCKET'),
    messagingSenderId: _getRequiredEnvVar('FIREBASE_MESSAGING_SENDER_ID'),
    appId: _getRequiredEnvVar('FIREBASE_APP_ID'),
  );
} 