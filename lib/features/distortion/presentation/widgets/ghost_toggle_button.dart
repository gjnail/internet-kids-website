import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_kids_website/features/distortion/presentation/bloc/distortion_bloc.dart';

class GhostToggleButton extends StatelessWidget {
  const GhostToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DistortionBloc, DistortionState>(
      builder: (context, state) {
        final ghostState = state.ghostState;
        return Transform.scale(
          scale: ghostState.isGhostMode ? 1.0 + ghostState.intensity * 0.05 : 1.0,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: ghostState.currentColor,
                width: ghostState.isGhostMode ? 2 + ghostState.intensity * 2 : 2,
              ),
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
            child: TextButton(
              onPressed: () => context.read<DistortionBloc>().add(ToggleGhostMode()),
              child: Text(
                ghostState.isGhostMode ? 'GHOST MODE: ON' : 'GHOST MODE: OFF',
                style: TextStyle(
                  color: ghostState.currentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: ghostState.isGhostMode
                      ? [
                          Shadow(
                            color: ghostState.currentColor,
                            blurRadius: 20 * ghostState.intensity,
                          )
                        ]
                      : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 