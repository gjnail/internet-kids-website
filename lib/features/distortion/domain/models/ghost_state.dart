import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GhostState extends Equatable {
  final bool isGhostMode;
  final double intensity;
  final Color currentColor;
  final List<Offset> ghostParticles;

  const GhostState({
    required this.isGhostMode,
    required this.intensity,
    required this.currentColor,
    required this.ghostParticles,
  });

  static const Color ghostColor = Color(0xFFFF0000);

  GhostState copyWith({
    bool? isGhostMode,
    double? intensity,
    Color? currentColor,
    List<Offset>? ghostParticles,
  }) {
    return GhostState(
      isGhostMode: isGhostMode ?? this.isGhostMode,
      intensity: intensity ?? this.intensity,
      currentColor: currentColor ?? this.currentColor,
      ghostParticles: ghostParticles ?? this.ghostParticles,
    );
  }

  @override
  List<Object?> get props => [isGhostMode, intensity, currentColor, ghostParticles];
} 