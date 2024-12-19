import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:internet_kids_website/core/routes/app_router.dart';

class SuccessReverbPage extends StatelessWidget {
  const SuccessReverbPage({super.key});

  Future<void> _handleMacDownload(BuildContext context) async {
    try {
      print('Starting Mac download process...');
      
      // Initialize Firebase if not already initialized
      if (Firebase.apps.isEmpty) {
        print('Initializing Firebase...');
        await Firebase.initializeApp();
      }

      print('Getting Firebase Storage instance...');
      final storage = FirebaseStorage.instance;
      
      print('Creating reference to Mac file...');
      final macRef = storage.ref().child('IKReverb/mac/IKReverb-1.0.0-macOS.pkg');

      print('Getting download URL...');
      final macUrl = await macRef.getDownloadURL();
      print('Mac URL: $macUrl');

      print('Opening download window...');
      // Create invisible anchor element and trigger click
      final macAnchor = html.AnchorElement(href: macUrl)
        ..setAttribute('download', 'IKReverb-1.0.0-macOS.pkg')
        ..style.display = 'none';
        
      html.document.body!.children.add(macAnchor);
      
      macAnchor.click();
      
      // Clean up the anchor element
      macAnchor.remove();
    } catch (e, stackTrace) {
      print('Download error: $e');
      print('Stack trace: $stackTrace');
      if (context.mounted) {
        _showErrorDialog(context, e);
      }
    }
  }

  Future<void> _handleWindowsDownload(BuildContext context) async {
    try {
      print('Starting Windows download process...');
      
      // Initialize Firebase if not already initialized
      if (Firebase.apps.isEmpty) {
        print('Initializing Firebase...');
        await Firebase.initializeApp();
      }

      print('Getting Firebase Storage instance...');
      final storage = FirebaseStorage.instance;
      
      print('Creating reference to Windows file...');
      final windowsRef = storage.ref().child('IKReverb/windows/IKReverb-Windows.zip');

      print('Getting download URL...');
      final windowsUrl = await windowsRef.getDownloadURL();
      print('Windows URL: $windowsUrl');

      print('Opening download window...');
      html.window.open(windowsUrl, '_blank');
    } catch (e, stackTrace) {
      print('Download error: $e');
      print('Stack trace: $stackTrace');
      if (context.mounted) {
        _showErrorDialog(context, e);
      }
    }
  }

  void _showErrorDialog(BuildContext context, dynamic error) {
    print('Showing error dialog: $error');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF280040),
        title: const Text(
          'Download Error',
          style: TextStyle(color: Colors.cyan),
        ),
        content: SingleChildScrollView(
          child: Text(
            'Failed to start download: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.cyan),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF280040),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.cyan,
                  size: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  'THANK YOU FOR YOUR PURCHASE!',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan.withOpacity(0.5)),
                    color: Colors.black12,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Choose your platform to download:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _handleMacDownload(context),
                            icon: const Icon(Icons.apple, color: Colors.black),
                            label: const Text(
                              'DOWNLOAD FOR MAC',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: () => _handleWindowsDownload(context),
                            icon: const Icon(Icons.window, color: Colors.black),
                            label: const Text(
                              'DOWNLOAD FOR WINDOWS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Note: Mac download includes both AU and VST3 plugins',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Need help? Contact support@internetkidsmaketechno.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.home),
                  child: const Text(
                    'Return to Home',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 