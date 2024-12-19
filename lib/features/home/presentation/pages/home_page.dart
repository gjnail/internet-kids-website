import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_kids_website/features/home/presentation/bloc/home_bloc.dart';
import 'package:internet_kids_website/features/home/presentation/widgets/animated_title.dart';
import 'package:internet_kids_website/features/home/presentation/widgets/plugin_card.dart';
import 'package:internet_kids_website/shared/widgets/grid_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final raveState = state.raveState;
        return Scaffold(
          body: Stack(
            children: [
              RepaintBoundary(
                child: CustomPaint(
                  size: Size.infinite,
                  painter: GridPainter(
                    animation: _controller,
                    raveMode: raveState.isRaveMode,
                    intensity: raveState.intensity,
                    color: raveState.currentColor,
                    ghostParticles: const [],
                    isLowPerformanceMode: isSmallScreen,
                  ),
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
                          const AnimatedTitle(),
                          const SizedBox(height: 60),
                          const PluginCard(),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 