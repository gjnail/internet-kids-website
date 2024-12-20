import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internet_kids_website/app.dart';
import 'package:internet_kids_website/core/injection/injection.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables in development
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // In production, we'll use build-time environment variables
    print('No .env file found, using build-time environment variables');
  }
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFF280040),
          body: Center(
            child: Text(
              'Error: Failed to initialize Firebase.\n'
              'Please check the configuration and try again.',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
    return;
  }
  
  // Configure dependency injection
  await configureDependencies();
  
  runApp(const InternetKidsWebsite());
}
