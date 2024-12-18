import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_kids_website/features/distortion/domain/models/ghost_state.dart';

// Events
abstract class DistortionEvent extends Equatable {
  const DistortionEvent();

  @override
  List<Object?> get props => [];
}

class ToggleGhostMode extends DistortionEvent {}
class UpdateGhostState extends DistortionEvent {
  final double intensity;

  const UpdateGhostState({
    required this.intensity,
  });

  @override
  List<Object?> get props => [intensity];
}

// State
class DistortionState extends Equatable {
  final GhostState ghostState;

  const DistortionState({
    required this.ghostState,
  });

  factory DistortionState.initial() {
    final random = math.Random();
    final ghostParticles = List.generate(
      50,
      (i) => Offset(
        random.nextDouble() * 2 - 1,
        random.nextDouble() * 2 - 1,
      ),
    );

    return DistortionState(
      ghostState: GhostState(
        isGhostMode: false,
        intensity: 0.0,
        currentColor: Colors.cyan,
        ghostParticles: ghostParticles,
      ),
    );
  }

  DistortionState copyWith({
    GhostState? ghostState,
  }) {
    return DistortionState(
      ghostState: ghostState ?? this.ghostState,
    );
  }

  @override
  List<Object?> get props => [ghostState];
}

// BLoC
class DistortionBloc extends Bloc<DistortionEvent, DistortionState> {
  Timer? _ghostTimer;

  DistortionBloc() : super(DistortionState.initial()) {
    on<ToggleGhostMode>(_onToggleGhostMode);
    on<UpdateGhostState>(_onUpdateGhostState);
  }

  void _onToggleGhostMode(ToggleGhostMode event, Emitter<DistortionState> emit) {
    final newGhostMode = !state.ghostState.isGhostMode;
    
    emit(state.copyWith(
      ghostState: state.ghostState.copyWith(
        isGhostMode: newGhostMode,
        intensity: newGhostMode ? state.ghostState.intensity : 0.0,
        currentColor: newGhostMode ? GhostState.ghostColor : Colors.cyan,
      ),
    ));

    _startGhostTimer();
  }

  void _onUpdateGhostState(UpdateGhostState event, Emitter<DistortionState> emit) {
    if (!state.ghostState.isGhostMode) return;

    emit(state.copyWith(
      ghostState: state.ghostState.copyWith(
        intensity: event.intensity,
        currentColor: GhostState.ghostColor.withOpacity(event.intensity),
      ),
    ));
  }

  void _startGhostTimer() {
    _ghostTimer?.cancel();
    if (state.ghostState.isGhostMode) {
      _ghostTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        final intensity = (math.sin(_ghostTimer!.tick * 0.1) * 0.3 + 0.7).clamp(0.0, 1.0);
        add(UpdateGhostState(intensity: intensity));
      });
    }
  }

  @override
  Future<void> close() {
    _ghostTimer?.cancel();
    return super.close();
  }
} 