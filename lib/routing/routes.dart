import 'package:flutterwidgets/features/history/presentation/views/profile_screen.dart';
import 'package:flutterwidgets/features/home/presentation/views/home_screen.dart';
import 'package:go_router/go_router.dart';

//context.push('/profile'); // Pushes ProfileScreen onto the stack
//context.go('/profile'); // Replaces current screen
final GoRouter route = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
  GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
]);
