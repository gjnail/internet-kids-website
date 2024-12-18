import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_kids_website/core/routes/app_router.dart';
import 'package:internet_kids_website/core/theme/app_theme.dart';
import 'package:internet_kids_website/features/home/presentation/bloc/home_bloc.dart';
import 'package:internet_kids_website/features/distortion/presentation/bloc/distortion_bloc.dart';

class InternetKidsWebsite extends StatelessWidget {
  const InternetKidsWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<DistortionBloc>(
          create: (context) => DistortionBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Internet Kids',
        theme: AppTheme.darkTheme,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.home,
      ),
    );
  }
} 