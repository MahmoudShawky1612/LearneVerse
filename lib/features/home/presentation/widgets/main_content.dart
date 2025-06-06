import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/core/providers/user_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_posts.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/community_grid.dart';
import 'package:provider/provider.dart';

import '../../models/community_model.dart';

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  late List<Post> posts;
  late List<Community> communities;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    posts = Post.generateDummyPosts(15);
    communities = Community.generateDummyCommunities();
  }

  void _onPostDelete(String id) {
    setState(() {
      posts.removeWhere((post) => post.id == id);
    });
  }

  Future<void> _refreshContent() async {
    setState(() {
      isRefreshing = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      _loadData();
      isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    final currentUser = Provider.of<UserProvider>(context).currentUser;

    bool matchesInterests(List<String> tags, List<String> interests) {
      final lowerTags = tags.map((tag) => tag.toLowerCase()).toList();
      final lowerInterests =
          interests.map((interest) => interest.toLowerCase()).toList();

      for (var interest in lowerInterests) {
        for (var tag in lowerTags) {
          if (tag == interest ||
              tag.contains(interest) ||
              interest.contains(tag)) {
            return true;
          }
        }
      }

      return false;
    }

    final List<Community> recommendedCommunities =
        communities.where((community) {
      return matchesInterests(community.tags, currentUser.interests);
    }).toList();

    final communitiesToShow = recommendedCommunities.isNotEmpty
        ? recommendedCommunities
        : communities.take(4).toList();

    final List<Post> recommendedPosts = posts.where((post) {
      bool tagMatches = matchesInterests(post.tags, currentUser.interests);

      bool communityMatches = false;


      final matchingCommunities =
          communities.where((c) => c.name == post.communityName);
      if (matchingCommunities.isNotEmpty) {
        Community postCommunity = matchingCommunities.first;
        communityMatches =
            matchesInterests(postCommunity.tags, currentUser.interests);
      }

      return tagMatches || communityMatches;
    }).toList();


    final postsToShow = recommendedPosts.isNotEmpty
        ? recommendedPosts
        : (recommendedPosts.length < 3
            ? posts.take(5).toList()
            : recommendedPosts);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: EdgeInsets.only(
              top: 16.h,
              left: 16.w,
              right: 16.w,
              bottom: 8.h,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 50.h,
              bottom: 10.h,
              left: 8.w,
              right: 8.w,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              gradient: themeExtension?.containerGradient,
              borderRadius: BorderRadius.circular(8.r),
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
                        recommendedCommunities.isNotEmpty
                            ? 'Communities For You'
                            : 'Popular Communities',
                        style: textTheme.headlineSmall?.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2.w,
                        ),
                      ),
                    ),

                  ],
                ),
                CommunityGrid(communities: communitiesToShow),
                if (recommendedCommunities.isEmpty &&
                    currentUser.interests.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: colorScheme.primary.withOpacity(0.2)),
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
                              'No communities match your interests. Try exploring more communities or updating your interests.',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: colorScheme.onSurface.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(
              bottom: 75.h,
              left: 8.w,
              right: 8.w,
            ),
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 12.h,
              bottom: 12.h,
            ),
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
                        recommendedPosts.isNotEmpty
                            ? 'Posts For You'
                            : 'Popular Posts',
                        style: textTheme.headlineSmall?.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    if (recommendedPosts.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
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
                if (recommendedPosts.isEmpty &&
                    currentUser.interests.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: colorScheme.primary.withOpacity(0.2)),
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
                                'No posts match your interests',
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
                              color: colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          GestureDetector(
                            onTap: _refreshContent,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Text(
                                'Refresh Content',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                BuildPosts(
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  posts: postsToShow,
                  delete: _onPostDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
