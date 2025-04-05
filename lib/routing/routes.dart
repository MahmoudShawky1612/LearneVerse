import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/comments/presentation/views/comments_screen.dart';
import 'package:flutterwidgets/features/community/presentation/views/community_screen.dart';
import 'package:flutterwidgets/features/discover/presentation/views/discover_screen.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/views/home_screen.dart';
import 'package:flutterwidgets/features/home/presentation/views/main_screen.dart';
import 'package:flutterwidgets/features/user_selection_screen.dart';
import 'package:flutterwidgets/features/calendar/presentation/views/calendar_screen.dart';
import 'package:go_router/go_router.dart';
import '../features/profile/presentation/views/profile_screen.dart';

//context.push('/profile'); // Pushes ProfileScreen onto the stack
//context.go('/profile'); // Replaces current screen
final GoRouter route = GoRouter(
  initialLocation: '/user-selection',
  routes: [
    GoRoute(
      path: '/user-selection',
      builder: (context, state) => const UserSelectionScreen(),
    ),
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
      builder: (context, state) => const ProfileScreen(),
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
      builder: (context, state) => CommunityScreen(community: state.extra),
    ),
  ],
);
