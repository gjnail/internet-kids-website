import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:internet_kids_website/features/home/domain/models/rave_state.dart';

// Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class ToggleRaveMode extends HomeEvent {}
class UpdateRaveState extends HomeEvent {
  final double intensity;
  final int currentIndex;

  const UpdateRaveState({
    required this.intensity,
    required this.currentIndex,
  });

  @override
  List<Object?> get props => [intensity, currentIndex];
}

// State
class HomeState extends Equatable {
  final RaveState raveState;

  const HomeState({
    required this.raveState,
  });

  factory HomeState.initial() => HomeState(
    raveState: RaveState(
      isRaveMode: false,
      intensity: 0.0,
      currentIndex: 0,
      currentColor: Colors.cyan,
    ),
  );

  HomeState copyWith({
    RaveState? raveState,
  }) {
    return HomeState(
      raveState: raveState ?? this.raveState,
    );
  }

  @override
  List<Object?> get props => [raveState];
}

// BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Timer? _raveTimer;

  HomeBloc() : super(HomeState.initial()) {
    on<ToggleRaveMode>(_onToggleRaveMode);
    on<UpdateRaveState>(_onUpdateRaveState);
  }

  void _onToggleRaveMode(ToggleRaveMode event, Emitter<HomeState> emit) {
    final newRaveMode = !state.raveState.isRaveMode;
    
    emit(state.copyWith(
      raveState: state.raveState.copyWith(
        isRaveMode: newRaveMode,
        intensity: newRaveMode ? state.raveState.intensity : 0.0,
      ),
    ));

    _startRaveTimer();
  }

  void _onUpdateRaveState(UpdateRaveState event, Emitter<HomeState> emit) {
    if (!state.raveState.isRaveMode) return;

    final nextColor = RaveState.raveColors[(event.currentIndex + 1) % RaveState.raveColors.length];
    final currentColor = Color.lerp(
      RaveState.raveColors[event.currentIndex],
      nextColor,
      event.intensity,
    )!;

    emit(state.copyWith(
      raveState: state.raveState.copyWith(
        intensity: event.intensity,
        currentIndex: event.currentIndex,
        currentColor: currentColor,
      ),
    ));
  }

  void _startRaveTimer() {
    _raveTimer?.cancel();
    if (state.raveState.isRaveMode) {
      _raveTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        final intensity = math.sin(currentTime * 0.01) * 0.5 + 0.5;
        final currentIndex = (state.raveState.currentIndex + 1) % RaveState.raveText.length;
        
        add(UpdateRaveState(
          intensity: intensity,
          currentIndex: currentIndex,
        ));
      });
    }
  }

  @override
  Future<void> close() {
    _raveTimer?.cancel();
    return super.close();
  }
} 