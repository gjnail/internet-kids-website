import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_kids_website/core/routes/app_router.dart';
import 'package:internet_kids_website/features/home/domain/models/rave_state.dart';
import 'package:internet_kids_website/features/home/presentation/bloc/home_bloc.dart';
import 'package:internet_kids_website/features/home/presentation/widgets/animated_title.dart';
import 'package:internet_kids_website/features/home/presentation/widgets/project_card.dart';
import 'package:internet_kids_website/features/home/presentation/widgets/rave_toggle_button.dart';
import 'package:internet_kids_website/features/home/presentation/widgets/social_button.dart';
import 'package:internet_kids_website/shared/widgets/grid_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final raveState = state.raveState;
        return Scaffold(
          body: Stack(
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: GridPainter(
                  animation: _controller,
                  raveMode: raveState.isRaveMode,
                  intensity: raveState.intensity,
                  color: raveState.currentColor,
                  ghostParticles: const [],
                ),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          const RaveToggleButton(),
                          const SizedBox(height: 40),
                          const AnimatedTitle(),
                          const SizedBox(height: 60),
                          Container(
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
                                    'PROJECTS',
                                    style: TextStyle(
                                      fontSize: 36,
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
                                const SizedBox(height: 30),
                                ProjectCard(
                                  title: 'DISTORTION',
                                  description: 'Destroy your kicks with style',
                                  onTap: () => Navigator.pushNamed(context, AppRouter.distortion),
                                ),
                                const SizedBox(height: 20),
                                ProjectCard(
                                  title: 'COMING SOON',
                                  description: 'More techno weapons incoming',
                                  onTap: () => {},
                                  enabled: false,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            children: const [
                              SocialButton(
                                text: 'SOUNDCLOUD',
                                url: 'https://soundcloud.com/internetkidsmaketechno',
                              ),
                              SocialButton(
                                text: 'INSTAGRAM',
                                url: 'https://instagram.com/internetkidsmaketechno',
                              ),
                              SocialButton(
                                text: 'YOUTUBE',
                                url: 'https://youtube.com/@internetkidsmaketechno',
                              ),
                              SocialButton(
                                text: 'TIKTOK',
                                url: 'https://tiktok.com/@internetkidsmaketechno',
                              ),
                              SocialButton(
                                text: 'TWITTER',
                                url: 'https://twitter.com/internetkidstec',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: RaveState.raveColors[raveState.currentIndex].withOpacity(0.3),
                                ),
                              ),
                            ),
                            child: Text(
                              '@internetkidsmaketechno',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: RaveState.raveColors[raveState.currentIndex],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 