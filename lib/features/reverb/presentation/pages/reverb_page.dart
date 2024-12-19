import 'package:flutter/material.dart';
import 'package:internet_kids_website/features/reverb/presentation/widgets/feature_item.dart';
import 'package:internet_kids_website/features/reverb/presentation/widgets/purchase_dialog.dart';
import 'package:internet_kids_website/shared/widgets/grid_painter.dart';

class ReverbPage extends StatefulWidget {
  const ReverbPage({super.key});

  @override
  State<ReverbPage> createState() => _ReverbPageState();
}

class _ReverbPageState extends State<ReverbPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Color mainColor = Colors.cyan;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePurchase(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PurchaseDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: GridPainter(
                  animation: _controller,
                  raveMode: false,
                  intensity: 0.5,
                  color: mainColor,
                  ghostParticles: const [],
                ),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [mainColor, Colors.blue],
                            ).createShader(bounds),
                            child: Text(
                              'INTERNET KIDS\nREVERB',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: mainColor,
                                    offset: const Offset(4, 4),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: mainColor,
                                width: 2,
                              ),
                              color: Colors.black26,
                            ),
                            child: Text(
                              '\$15',
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: mainColor.withOpacity(0.5),
                                width: 2,
                              ),
                              color: Colors.black12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    'FEATURES',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: mainColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const FeatureItem(text: 'Multiple reverb algorithms (Room, Hall, Plate, Spring)'),
                                const FeatureItem(text: 'Pre-delay control for precise spatial depth'),
                                const FeatureItem(text: 'High-quality modulation for movement'),
                                const FeatureItem(text: 'Low cut and high cut filters'),
                                const FeatureItem(text: 'Real-time parameter visualization'),
                                const FeatureItem(text: 'AU/VST3 for macOS'),
                                const FeatureItem(text: 'VST3 for Windows'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () => _handlePurchase(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 20,
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'BUY NOW',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: mainColor,
              size: 32,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
} 