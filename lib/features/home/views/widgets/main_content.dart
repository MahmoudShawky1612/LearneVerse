import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/home/logic/cubit/community_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/post_feed_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/post_feed_states.dart';
import 'package:flutterwidgets/features/home/views/widgets/build_posts.dart';
import 'package:flutterwidgets/features/home/views/widgets/community_grid.dart';
import 'package:flutterwidgets/utils/loading_state.dart';

import '../../../../utils/error_state.dart';
import '../../logic/cubit/community_states.dart';

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  @override
  void initState() {
    super.initState();
    fetchCommunities();
    fetchPosts();
  }

  void fetchCommunities() {
    context.read<CommunityCubit>().fetchCommunities();
  }

  void fetchPosts() {
    context.read<PostFeedCubit>().fetchFeedPosts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = theme.extension<AppThemeExtension>();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PostFeedCubit>().fetchFeedPosts(forceRefresh: true);
        context.read<CommunityCubit>().fetchCommunities(forceRefresh: true);
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 7.h),
            BlocBuilder<CommunityCubit, CommunityStates>(
              builder: (context, state) {
                if (state is CommunityLoading) {
                  return const Center(child: LoadingState());
                } else if (state is CommunityFailure) {
                  return Center(
                      child: ErrorStateWidget(
                    message: state.message,
                    onRetry: fetchCommunities,
                  ));
                } else if (state is CommunitySuccess) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      gradient: themeExtension?.containerGradient,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.onSurface.withOpacity(0.15),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.communities.isNotEmpty
                              ? 'Communities For You'
                              : 'Popular Communities',
                          style: textTheme.headlineSmall?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2.w,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        CommunityGrid(communities: state.communities),
                        if (state.communities.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: colorScheme.surface.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                    color:
                                        colorScheme.primary.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: colorScheme.primary,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      'Noting in here yet.',
                                      style: TextStyle(
                                          fontSize: 13.sp, color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('Unknown state'));
              },
            ),
            BlocBuilder<PostFeedCubit, PostFeedState>(
              builder: (BuildContext context, PostFeedState state) {
                if (state is PostFeedLoading) {
                  return const Center(child: LoadingState());
                } else if (state is PostFeedError) {
                  return Center(
                      child: ErrorStateWidget(
                          message: state.message, onRetry: fetchPosts));
                } else if (state is PostFeedLoaded) {
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: 75.h,
                      left: 8.w,
                      right: 8.w,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      gradient: themeExtension?.containerGradient,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.onSurface.withOpacity(0.15),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                state.posts.isNotEmpty
                                    ? 'Posts For You'
                                    : 'Popular Posts',
                                style: textTheme.headlineSmall?.copyWith(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            if (state.posts.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.1),
                                ),
                                child: Text(
                                  'Personalized',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        if (state.posts.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: colorScheme.surface.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color:
                                        colorScheme.primary.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 18.w,
                                        color: colorScheme.primary,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Join communities to see posts here',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'We\'re showing you popular posts instead. Try refreshing or updating your interests.',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        BuildPosts(
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          posts: state.posts,
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                    child: ErrorStateWidget(
                  onRetry: () {},
                  message: "Oppps!...unexpected error",
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
