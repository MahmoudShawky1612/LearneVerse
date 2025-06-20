import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/core/providers/theme_provider.dart';
import 'package:flutterwidgets/features/comments/logic/cubit/comment_cubit.dart';
import 'package:flutterwidgets/features/comments/service/comment_service.dart';
import 'package:flutterwidgets/features/community/logic/cubit/forum_cubit.dart';
import 'package:flutterwidgets/features/community/logic/cubit/single_community_cubit.dart';
import 'package:flutterwidgets/features/community/service/forum_service.dart';
import 'package:flutterwidgets/features/community/service/join_requests_service.dart';
import 'package:flutterwidgets/features/discover/logic/cubit/favorite_communities_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/community_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/downvote_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/post_feed_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/upvote_cubit.dart';
import 'package:flutterwidgets/features/home/service/feed_post_service.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/user_comments_cubit.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/user_communities_cubit.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/user_contributions_cubit.dart';
import 'package:flutterwidgets/features/profile/service/user_comments.service.dart';
import 'package:flutterwidgets/features/quizzes/logic/cubit/quiz_cubit.dart';
import 'package:flutterwidgets/routing/routes.dart';
import 'package:provider/provider.dart';

import 'features/community/logic/cubit/classroom_cubit.dart';
import 'features/community/logic/cubit/community_members_cubit.dart';
import 'features/community/logic/cubit/join_requests_cubit.dart';
import 'features/community/service/classroom_service.dart';
import 'features/community/service/community_members_api_service.dart';
import 'features/community/service/single_community_service.dart';
import 'features/discover/logic/cubit/search_cubit.dart';
import 'features/discover/service/favorite_service.dart';
import 'features/discover/service/search_service.dart';
import 'features/home/service/community_service.dart';
import 'features/login/logic/cubit/auth_cubit.dart';
import 'features/login/service/auth_api_service.dart';
import 'features/profile/logic/cubit/profile_cubit.dart';
import 'features/profile/logic/cubit/user_posts_cubit.dart';
import 'features/profile/service/profile_api_services.dart';
import 'features/profile/service/user_communities_service.dart';
import 'features/profile/service/user_contributions_service.dart';
import 'features/profile/service/user_posts_service.dart';
import 'features/quizzes/service/quiz_service.dart';
import 'features/sections/logic/cubit/sections_cubit.dart';
import 'features/sections/service/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(AuthApiService()),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(UserProfileApiService()),
        ),
        BlocProvider<CommunityCubit>(
            create: (_) => CommunityCubit(CommunityApiService())),
        BlocProvider<PostFeedCubit>(
            create: (_) => PostFeedCubit(FeedPostsApiService())),
        BlocProvider<CommentCubit>(
          create: (_) => CommentCubit(CommentService()),
        ),
        BlocProvider<SingleCommunityCubit>(
            create: (_) => SingleCommunityCubit(SingleCommunityApiService())),
        BlocProvider<ClassroomCubit>(
            create: (_) => ClassroomCubit(ClassroomService())),
        BlocProvider<ForumCubit>(create: (_) => ForumCubit(ForumApiService())),
        BlocProvider<CommunityMembersCubit>(
            create: (_) => CommunityMembersCubit(CommunityMembersApiService())),
        BlocProvider<CommunityRoleCubit>(
            create: (_) => CommunityRoleCubit(ApiService())),
        BlocProvider<UserPostCubit>(
            create: (_) => UserPostCubit(UserPostApiService())),
        BlocProvider<UserCommentsCubit>(
            create: (_) => UserCommentsCubit(UserCommentsApiService())),
        BlocProvider<UserCommunitiesCubit>(
            create: (_) => UserCommunitiesCubit(UserCommunitiesApiService())),
        BlocProvider<UserContributionsCubit>(
            create: (_) =>
                UserContributionsCubit(UserContributionsApiService())),
        BlocProvider<SearchCubit>(create: (_) => SearchCubit(SearchService())),
        BlocProvider<FavoriteCubit>(
            create: (_) => FavoriteCubit(FavoriteService())),
        BlocProvider<SectionsCubit>(
            create: (_) => SectionsCubit(SectionsApiService())),
        BlocProvider<UpvoteCubit>(create: (_) => UpvoteCubit(FeedPostsApiService())),
        BlocProvider<DownvoteCubit>(create: (_) =>DownvoteCubit(FeedPostsApiService())),
        BlocProvider<QuizCubit>(create: (_) => QuizCubit(QuizService())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ScreenUtilInit(
          minTextAdapt: true,
          designSize: const Size(360, 690),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: route,
            themeMode: themeProvider.themeMode,
            darkTheme: _buildDarkTheme(),
            theme: _buildLightTheme(),
            builder: (context, child) {
              return child!;
            },
          ),
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimary,
        tertiary: AppColors.accent,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardColor: AppColors.surfaceLight,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
        titleLarge: TextStyle(color: AppColors.textPrimary),
        titleMedium: TextStyle(color: AppColors.textPrimary),
        titleSmall: TextStyle(color: AppColors.textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
      ),
      extensions: const [
        AppThemeExtension.light,
      ],
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        tertiary: AppColors.accent,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.surfaceDark,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimaryDark),
        bodyMedium: TextStyle(color: AppColors.textPrimaryDark),
        titleLarge: TextStyle(color: AppColors.textPrimaryDark),
        titleMedium: TextStyle(color: AppColors.textPrimaryDark),
        titleSmall: TextStyle(color: AppColors.textSecondaryDark),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
      ),
      extensions: const [
        AppThemeExtension.dark,
      ],
    );
  }
}
