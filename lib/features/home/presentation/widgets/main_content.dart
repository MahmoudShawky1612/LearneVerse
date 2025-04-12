import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/core/providers/user_provider.dart';
import 'package:flutterwidgets/core/utils/responsive_utils.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_posts.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/community_grid.dart';
import 'package:provider/provider.dart';

import '../../models/community_model.dart';
import '../../models/author_model.dart';

class MainContent extends StatefulWidget {
  MainContent({super.key});

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
  
  // Load data method
  void _loadData() {
    posts = Post.generateDummyPosts(15);
    communities = Community.generateDummyCommunities();
  }
  
  // Method to delete posts
  void _onPostDelete(String id) {
    setState(() {
      posts.removeWhere((post) => post.id == id);
    });
  }

  Future<void> _refreshContent() async {
    setState(() {
      isRefreshing = true;
    });
    
    // Simulate network delay
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
    final isMobile = context.isMobile;
    
    // Get the current user from the provider
    final currentUser = Provider.of<UserProvider>(context).currentUser;
    
    // Improved interest matching function
    bool matchesInterests(List<String> tags, List<String> interests) {
      // Make tag and interest comparison case-insensitive
      final lowerTags = tags.map((tag) => tag.toLowerCase()).toList();
      final lowerInterests = interests.map((interest) => interest.toLowerCase()).toList();
      
      // Check for any direct match or partial match
      for (var interest in lowerInterests) {
        for (var tag in lowerTags) {
          if (tag == interest || tag.contains(interest) || interest.contains(tag)) {
            return true;
          }
        }
      }
      
      return false;
    }
    
    // Filter communities that match user interests - stricter filtering
    final List<Community> recommendedCommunities = communities.where((community) {
      return matchesInterests(community.tags, currentUser.interests);
    }).toList();
    
    // If no matches, show only a limited number of default communities
    final communitiesToShow = recommendedCommunities.isNotEmpty 
        ? recommendedCommunities 
        : communities.take(4).toList();
        
    // Filter posts that match user interests - stricter filtering
    final List<Post> recommendedPosts = posts.where((post) {
      // Direct tag match
      bool tagMatches = matchesInterests(post.tags, currentUser.interests);
      
      // Community match (check if the post is from a community that matches interests)
      bool communityMatches = false;
      
      // Find the community for the post
      final matchingCommunities = communities.where((c) => c.name == post.communityName);
      if (matchingCommunities.isNotEmpty) {
        Community postCommunity = matchingCommunities.first;
        communityMatches = matchesInterests(postCommunity.tags, currentUser.interests);
      }
        
      return tagMatches || communityMatches;
    }).toList();
    
    // If very few matches, show a limited set of posts
    final postsToShow = recommendedPosts.isNotEmpty 
        ? recommendedPosts 
        : (recommendedPosts.length < 3 ? posts.take(5).toList() : recommendedPosts);
        
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with refresh button
          Container(
            padding: EdgeInsets.only(
              top: context.h(16),
              left: isMobile ? context.w(12) : context.w(16),
              right: isMobile ? context.w(12) : context.w(16),
              bottom: context.h(8),
            ),
          ),
          
          Container(
            margin: EdgeInsets.only(
              top: context.h(50), 
              bottom: context.h(10),
              left: isMobile ? 0 : context.w(8),
              right: isMobile ? 0 : context.w(8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? context.w(12) : context.w(16),
              vertical: context.h(12)
            ),
            decoration: isMobile
                ? null
                : BoxDecoration(
            gradient: themeExtension?.containerGradient,
            borderRadius: BorderRadius.circular(8),
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
                          fontSize: isMobile ? 17 : 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                    if (recommendedCommunities.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(8),
                          vertical: context.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Personalized',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: isMobile ? 10 : 11,
                          ),
                        ),
                      ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: isRefreshing ? null : _refreshContent,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(12),
                              vertical: context.h(8),
                            ),
                            decoration: BoxDecoration(
                              color: isRefreshing
                                  ? colorScheme.primary.withOpacity(0.3)
                                  : colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isRefreshing)
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                else
                                  const Icon(Icons.refresh, color: Colors.white, size: 16),
                                SizedBox(width: context.w(4)),
                                Text(
                                  isRefreshing ? 'Refreshing...' : 'Refresh For You',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
                SizedBox(height: context.h(16)),
                CommunityGrid(communities: communitiesToShow),
                
                // Show message when no communities match user interests
                if (recommendedCommunities.isEmpty && currentUser.interests.isNotEmpty)
                Padding(
                    padding: EdgeInsets.only(top: context.h(12)),
                    child: Container(
                      padding: EdgeInsets.all(context.w(8)),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          SizedBox(width: context.w(8)),
                          Expanded(
                            child: Text(
                              'No communities match your interests. Try exploring more communities or updating your interests.',
                              style: TextStyle(
                                fontSize: 12,
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
          
          // Divider for mobile
          if (isMobile) const Divider(height: 1),
          
          // Posts section
          Container(
            margin: EdgeInsets.only(
              bottom: context.h(75),
              left: isMobile ? 0 : context.w(8),
              right: isMobile ? 0 : context.w(8),
            ),
            padding: EdgeInsets.only(
              left: isMobile ? context.w(12) : context.w(16),
              right: isMobile ? context.w(12) : context.w(16),
              top: context.h(12),
              bottom: isMobile ? 0 : context.h(12),
            ),
            decoration: isMobile
                ? null
                : BoxDecoration(
                    gradient: themeExtension?.containerGradient,
                    borderRadius: BorderRadius.circular(8),
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
                          fontSize: isMobile ? 17 : 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                    if (recommendedPosts.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(8),
                          vertical: context.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Personalized',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: isMobile ? 10 : 11,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: context.h(12)),
                
                // Empty state for no posts matching interests
                if (recommendedPosts.isEmpty && currentUser.interests.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: context.h(16)),
                    child: Container(
                      padding: EdgeInsets.all(context.w(12)),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 18,
                                color: colorScheme.primary,
                              ),
                              SizedBox(width: context.w(8)),
                              Text(
                                'No posts match your interests',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.h(8)),
                          Text(
                            'We\'re showing you popular posts instead. Try refreshing or updating your interests.',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(height: context.h(12)),
                          GestureDetector(
                            onTap: _refreshContent,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(12),
                                vertical: context.h(6),
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'Refresh Content',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
                  delete: _onPostDelete, // Pass delete callback
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
