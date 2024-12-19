import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_kids_website/features/home/domain/models/rave_state.dart';
import 'package:internet_kids_website/features/home/presentation/bloc/home_bloc.dart';

class AnimatedTitle extends StatelessWidget {
  const AnimatedTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final raveState = state.raveState;
        return Column(
          children: [
            Transform.scale(
              scale: raveState.isRaveMode ? 1.0 + raveState.intensity * 0.05 : 1.0,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    raveState.currentColor,
                    RaveState.raveColors[(raveState.currentIndex + 1) % RaveState.raveColors.length],
                  ],
                ).createShader(bounds),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'INTERNET KIDS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 600 ? 48 : 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: raveState.currentColor,
                            offset: const Offset(4, 4),
                            blurRadius: raveState.isRaveMode ? 8 + raveState.intensity * 12 : 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Transform.scale(
              scale: raveState.isRaveMode ? 1.0 + raveState.intensity * 0.2 : 1.0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    raveState.isRaveMode ? RaveState.raveText[raveState.currentIndex] : "AUDIO PLUGINS",
                    key: ValueKey<String>(raveState.isRaveMode ? RaveState.raveText[raveState.currentIndex] : "static"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: raveState.currentColor,
                      shadows: raveState.isRaveMode
                          ? [
                              Shadow(
                                color: raveState.currentColor,
                                blurRadius: 20 * raveState.intensity,
                              )
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
} 