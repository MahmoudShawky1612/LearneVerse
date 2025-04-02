import 'package:flutterwidgets/features/calender/presentation/views/calendar_screen.dart';
import 'package:flutterwidgets/features/discover/presentation/views/discover_screen.dart';
import 'package:flutterwidgets/features/home/presentation/views/home_screen.dart';
import 'package:flutterwidgets/features/home/presentation/views/main_screen.dart';
import 'package:go_router/go_router.dart';

import '../features/profile/presentation/views/profile_screen.dart';

//context.push('/profile'); // Pushes ProfileScreen onto the stack
//context.go('/profile'); // Replaces current screen
final GoRouter route = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (context, state) => const MainScreen()),
  GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
  GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
  GoRoute(path: '/discover', builder: (context, state) => const DiscoverScreen()),
  GoRoute(path: '/calendar', builder: (context, state) => const CalendarScreen()),
]);
