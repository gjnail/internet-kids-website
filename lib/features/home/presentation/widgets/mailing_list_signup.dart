import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_kids_website/features/home/presentation/bloc/home_bloc.dart';

class MailingListSignup extends StatefulWidget {
  const MailingListSignup({super.key});

  @override
  State<MailingListSignup> createState() => _MailingListSignupState();
}

class _MailingListSignupState extends State<MailingListSignup> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // TODO: Implement actual mailing list signup logic
        await Future.delayed(const Duration(seconds: 1)); // Simulated API call
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thanks for signing up!'),
              backgroundColor: Colors.cyan,
            ),
          );
          _emailController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final raveState = state.raveState;
        return Transform.scale(
          scale: raveState.isRaveMode ? 1.0 + raveState.intensity * 0.05 : 1.0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: raveState.currentColor.withOpacity(
                  raveState.isRaveMode ? 0.5 + raveState.intensity * 0.5 : 0.5,
                ),
              ),
              color: Colors.black12,
              boxShadow: raveState.isRaveMode
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
              children: [
                Transform.scale(
                  scale: raveState.isRaveMode ? 1.0 + raveState.intensity * 0.1 : 1.0,
                  child: Text(
                    'JOIN THE RAVE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: raveState.currentColor,
                      shadows: raveState.isRaveMode
                          ? [
                              Shadow(
                                color: raveState.currentColor,
                                blurRadius: 10 * raveState.intensity,
                              )
                            ]
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sign up for updates on new plugins and features',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            filled: true,
                            fillColor: Colors.black26,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: raveState.currentColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: raveState.currentColor.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: raveState.currentColor,
                                width: 2,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: raveState.currentColor,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          disabledBackgroundColor: raveState.currentColor.withOpacity(0.5),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                ),
                              )
                            : const Text(
                                'SUBSCRIBE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ],
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