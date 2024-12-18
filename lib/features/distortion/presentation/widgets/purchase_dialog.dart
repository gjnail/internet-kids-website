import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_kids_website/features/distortion/presentation/bloc/distortion_bloc.dart';

class PurchaseDialog extends StatelessWidget {
  static const String paymentLink = 'https://buy.stripe.com/7sI28gbCX8ds4OAfYY';

  const PurchaseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DistortionBloc, DistortionState>(
      builder: (context, state) {
        final ghostState = state.ghostState;
        return AlertDialog(
          backgroundColor: const Color(0xFF280040),
          title: Text(
            'PURCHASE',
            style: TextStyle(
              color: ghostState.currentColor,
              fontWeight: FontWeight.bold,
              shadows: ghostState.isGhostMode
                  ? [
                      Shadow(
                        color: ghostState.currentColor,
                        blurRadius: 10 * ghostState.intensity,
                      )
                    ]
                  : null,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: ghostState.isGhostMode ? 1.0 + ghostState.intensity * 0.05 : 1.0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ghostState.currentColor.withOpacity(0.5),
                      width: ghostState.isGhostMode ? 2 + ghostState.intensity * 2 : 2,
                    ),
                    color: Colors.black12,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'INTERNET KIDS DISTORTION',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ghostState.currentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Includes:',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '• AU/VST3 for macOS\n• VST3 for Windows',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '\$15',
                        style: TextStyle(
                          color: ghostState.currentColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Transform.scale(
                scale: ghostState.isGhostMode ? 1.0 + ghostState.intensity * 0.05 : 1.0,
                child: ElevatedButton(
                  onPressed: () {
                    html.window.open(paymentLink, '_blank');
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Redirecting to secure payment page...',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: ghostState.currentColor.withOpacity(0.8),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ghostState.currentColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    elevation: ghostState.isGhostMode ? 8 * ghostState.intensity : 2,
                    shadowColor: ghostState.isGhostMode ? ghostState.currentColor : Colors.black,
                  ),
                  child: Text(
                    'BUY NOW',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: ghostState.currentColor,
              width: ghostState.isGhostMode ? 2 + ghostState.intensity * 2 : 2,
            ),
          ),
        );
      },
    );
  }
} 