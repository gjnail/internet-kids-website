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

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: dotenv.get('FIREBASE_API_KEY'),
    authDomain: dotenv.get('FIREBASE_AUTH_DOMAIN'),
    projectId: dotenv.get('FIREBASE_PROJECT_ID'),
    storageBucket: dotenv.get('FIREBASE_STORAGE_BUCKET'),
    messagingSenderId: dotenv.get('FIREBASE_MESSAGING_SENDER_ID'),
    appId: dotenv.get('FIREBASE_APP_ID'),
  );
} 