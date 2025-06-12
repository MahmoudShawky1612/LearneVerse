import 'package:flutterwidgets/features/community/views/community_screen.dart';
import 'package:flutterwidgets/features/discover/views/discover_screen.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:flutterwidgets/features/home/views/home_screen.dart';
import 'package:flutterwidgets/features/home/views/main_screen.dart';
import 'package:flutterwidgets/features/login/views/login_screen.dart';
import 'package:flutterwidgets/features/calendar/views/calendar_screen.dart';
import 'package:go_router/go_router.dart';
import '../features/comments/views/comments_screen.dart';
import '../features/profile/views/profile_screen.dart';
import '../features/splash screen/views/splash_screen.dart';
import 'package:flutterwidgets/features/sections/views/sections_screen.dart';

final GoRouter route = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(userId: state.extra as int),
    ),
    GoRoute(
      path: '/discover',
      builder: (context, state) => const DiscoverScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/comments',
      builder: (context, state) => CommentsScreen(post: state.extra),
    ),
    GoRoute(
      path: '/community',
      builder: (context, state) =>
          CommunityScreen(community: state.extra as Community),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const PremiumLoginScreen(),
    ),
    // Section route
    GoRoute(
      path: '/sections',
      builder: (context, state) => SectionsScreen(
        classroomId: state.extra as int,
      ),
    ),
  ],
);
