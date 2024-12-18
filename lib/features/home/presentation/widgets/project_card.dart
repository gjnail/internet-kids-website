import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_kids_website/features/home/presentation/bloc/home_bloc.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool enabled;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final raveState = state.raveState;
        return MouseRegion(
          cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: enabled ? onTap : null,
            child: Transform.scale(
              scale: enabled && raveState.isRaveMode ? 1.0 + raveState.intensity * 0.05 : 1.0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: enabled 
                      ? raveState.currentColor
                      : raveState.currentColor.withOpacity(0.3),
                    width: raveState.isRaveMode && enabled ? 2 + raveState.intensity * 2 : 2,
                  ),
                  color: Colors.black26,
                  boxShadow: raveState.isRaveMode && enabled
                      ? [
                          BoxShadow(
                            color: raveState.currentColor.withOpacity(0.3),
                            blurRadius: 20 * raveState.intensity,
                            spreadRadius: 5 * raveState.intensity,
                          )
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: enabled 
                          ? raveState.currentColor
                          : raveState.currentColor.withOpacity(0.3),
                        shadows: raveState.isRaveMode && enabled
                            ? [
                                Shadow(
                                  color: raveState.currentColor,
                                  blurRadius: 10 * raveState.intensity,
                                )
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 18,
                        color: enabled ? Colors.white : Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 