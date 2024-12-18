import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RaveState extends Equatable {
  final bool isRaveMode;
  final double intensity;
  final int currentIndex;
  final Color currentColor;

  const RaveState({
    required this.isRaveMode,
    required this.intensity,
    required this.currentIndex,
    required this.currentColor,
  });

  static const List<String> raveText = [
    'UNTZ',
    'BOOM',
    'BASS',
    'DROP',
    'RAVE',
    'TECHNO',
  ];

  static const List<Color> raveColors = [
    Colors.cyan,
    Colors.purple,
    Colors.pink,
    Color(0xFFFF00FF), // Hot pink
    Color(0xFF00FF00), // Neon green
    Color(0xFFFF3300), // Neon orange
  ];

  RaveState copyWith({
    bool? isRaveMode,
    double? intensity,
    int? currentIndex,
    Color? currentColor,
  }) {
    return RaveState(
      isRaveMode: isRaveMode ?? this.isRaveMode,
      intensity: intensity ?? this.intensity,
      currentIndex: currentIndex ?? this.currentIndex,
      currentColor: currentColor ?? this.currentColor,
    );
  }

  @override
  List<Object?> get props => [isRaveMode, intensity, currentIndex, currentColor];
} 