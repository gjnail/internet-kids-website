import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_kids_website/features/home/presentation/bloc/home_bloc.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String url;

  const SocialButton({
    super.key,
    required this.text,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final raveState = state.raveState;
        return Transform.scale(
          scale: raveState.isRaveMode ? 1.0 + raveState.intensity * 0.1 : 1.0,
          child: ElevatedButton(
            onPressed: () => html.window.open(url, 'new'),
            style: ElevatedButton.styleFrom(
              backgroundColor: raveState.currentColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              elevation: raveState.isRaveMode ? 8 * raveState.intensity : 2,
              shadowColor: raveState.isRaveMode ? raveState.currentColor : Colors.black,
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
} 