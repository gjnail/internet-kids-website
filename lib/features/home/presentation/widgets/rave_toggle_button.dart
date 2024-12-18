import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_kids_website/features/home/presentation/bloc/home_bloc.dart';

class RaveToggleButton extends StatelessWidget {
  const RaveToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final raveState = state.raveState;
        return Transform.scale(
          scale: raveState.isRaveMode ? 1.0 + raveState.intensity * 0.1 : 1.0,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: raveState.currentColor,
                width: raveState.isRaveMode ? 2 + raveState.intensity * 2 : 2,
              ),
              boxShadow: raveState.isRaveMode
                  ? [
                      BoxShadow(
                        color: raveState.currentColor.withOpacity(0.5),
                        blurRadius: 20 * raveState.intensity,
                        spreadRadius: 5 * raveState.intensity,
                      )
                    ]
                  : null,
            ),
            child: TextButton(
              onPressed: () => context.read<HomeBloc>().add(ToggleRaveMode()),
              child: Text(
                raveState.isRaveMode ? 'RAVE MODE: ON' : 'RAVE MODE: OFF',
                style: TextStyle(
                  color: raveState.currentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
        );
      },
    );
  }
} 