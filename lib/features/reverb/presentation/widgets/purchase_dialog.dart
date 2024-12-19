import 'dart:html' as html;
import 'package:flutter/material.dart';

class PurchaseDialog extends StatelessWidget {
  static const String paymentLink = 'https://buy.stripe.com/00gcMUbCX9hw5SE4gh';
  
  const PurchaseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF280040),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_cart,
              color: Colors.cyan,
              size: 48,
            ),
            const SizedBox(height: 20),
            const Text(
              'INTERNET KIDS REVERB',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '\$15',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Includes:',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '• AU/VST3 for macOS\n• VST3 for Windows',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                html.window.open(paymentLink, '_blank');
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Redirecting to secure payment page...',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.cyan,
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'PROCEED TO PAYMENT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 