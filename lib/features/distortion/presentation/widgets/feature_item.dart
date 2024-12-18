import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_kids_website/features/distortion/presentation/bloc/distortion_bloc.dart';

class FeatureItem extends StatelessWidget {
  final String text;

  const FeatureItem({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DistortionBloc, DistortionState>(
      builder: (context, state) {
        final ghostState = state.ghostState;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Transform.scale(
            scale: ghostState.isGhostMode ? 1.0 + ghostState.intensity * 0.05 : 1.0,
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: ghostState.currentColor,
                ),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    shadows: ghostState.isGhostMode
                        ? [
                            Shadow(
                              color: ghostState.currentColor,
                              blurRadius: 5 * ghostState.intensity,
                            )
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 