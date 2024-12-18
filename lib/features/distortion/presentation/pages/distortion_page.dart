import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_kids_website/features/distortion/presentation/bloc/distortion_bloc.dart';
import 'package:internet_kids_website/features/distortion/presentation/widgets/feature_item.dart';
import 'package:internet_kids_website/features/distortion/presentation/widgets/ghost_toggle_button.dart';
import 'package:internet_kids_website/features/distortion/presentation/widgets/purchase_dialog.dart';
import 'package:internet_kids_website/shared/widgets/grid_painter.dart';

class DistortionPage extends StatefulWidget {
  const DistortionPage({super.key});

  @override
  State<DistortionPage> createState() => _DistortionPageState();
}

class _DistortionPageState extends State<DistortionPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    return BlocProvider(
      create: (context) => DistortionBloc(),
      child: BlocBuilder<DistortionBloc, DistortionState>(
        builder: (context, state) {
          final ghostState = state.ghostState;
          return Stack(
            children: [
              Scaffold(
                body: Stack(
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: GridPainter(
                        animation: _controller,
                        raveMode: ghostState.isGhostMode,
                        intensity: ghostState.intensity,
                        color: ghostState.currentColor,
                        ghostParticles: ghostState.ghostParticles,
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
                                Transform.scale(
                                  scale: ghostState.isGhostMode ? 1.0 + ghostState.intensity * 0.05 : 1.0,
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: ghostState.isGhostMode 
                                        ? [ghostState.currentColor, ghostState.currentColor.withRed(100)]
                                        : [ghostState.currentColor, Colors.purple],
                                    ).createShader(bounds),
                                    child: Text(
                                      'INTERNET KIDS\nDISTORTION',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: ghostState.currentColor,
                                            offset: const Offset(4, 4),
                                            blurRadius: ghostState.isGhostMode ? 8 + ghostState.intensity * 12 : 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Transform.scale(
                                  scale: ghostState.isGhostMode ? 1.0 + ghostState.intensity * 0.1 : 1.0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ghostState.currentColor,
                                        width: ghostState.isGhostMode ? 2 + ghostState.intensity * 2 : 2,
                                      ),
                                      color: Colors.black26,
                                      boxShadow: ghostState.isGhostMode
                                          ? [
                                              BoxShadow(
                                                color: ghostState.currentColor.withOpacity(0.5),
                                                blurRadius: 20 * ghostState.intensity,
                                                spreadRadius: 5 * ghostState.intensity,
                                              )
                                            ]
                                          : null,
                                    ),
                                    child: Text(
                                      '\$15',
                                      style: TextStyle(
                                        fontSize: 72,
                                        fontWeight: FontWeight.bold,
                                        color: ghostState.currentColor,
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
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ghostState.currentColor.withOpacity(
                                        ghostState.isGhostMode ? 0.5 + ghostState.intensity * 0.5 : 0.5,
                                      ),
                                      width: ghostState.isGhostMode ? 2 + ghostState.intensity * 2 : 2,
                                    ),
                                    color: Colors.black12,
                                    boxShadow: ghostState.isGhostMode
                                        ? [
                                            BoxShadow(
                                              color: ghostState.currentColor.withOpacity(0.3),
                                              blurRadius: 20 * ghostState.intensity,
                                              spreadRadius: 5 * ghostState.intensity,
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Transform.scale(
                                          scale: ghostState.isGhostMode ? 1.0 + ghostState.intensity * 0.1 : 1.0,
                                          child: Text(
                                            'FEATURES',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: ghostState.currentColor,
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
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const FeatureItem(text: 'Destroy your kicks with style'),
                                      const FeatureItem(text: 'Ghost Mode for ethereal sounds'),
                                      const FeatureItem(text: 'Real-time visualization'),
                                      const FeatureItem(text: '90s-inspired interface'),
                                      const FeatureItem(text: 'AU/VST3 for macOS'),
                                      const FeatureItem(text: 'VST3 for Windows'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Transform.scale(
                                  scale: ghostState.isGhostMode ? 1.0 + ghostState.intensity * 0.1 : 1.0,
                                  child: ElevatedButton(
                                    onPressed: () => _handlePurchase(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ghostState.currentColor,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 20,
                                      ),
                                      elevation: ghostState.isGhostMode ? 8 * ghostState.intensity : 2,
                                      shadowColor: ghostState.isGhostMode ? ghostState.currentColor : Colors.black,
                                    ),
                                    child: Text(
                                      'BUY NOW',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        shadows: ghostState.isGhostMode
                                            ? [
                                                Shadow(
                                                  color: Colors.white,
                                                  blurRadius: 10 * ghostState.intensity,
                                                )
                                              ]
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                const GhostToggleButton(),
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
                    color: ghostState.currentColor,
                    size: 32,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 