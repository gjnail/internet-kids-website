import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internet_kids_website/app.dart';
import 'package:internet_kids_website/core/injection/injection.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables with fallback to empty env
  try {
    await dotenv.load();
  } catch (e) {
    print('Warning: Failed to load .env file, using default values');
  }
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Configure dependency injection
  await configureDependencies();
  
  runApp(const InternetKidsWebsite());
}
