import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Initialize your dependencies here
  // For now, we'll just return since we don't have any dependencies to inject
  return;
} 