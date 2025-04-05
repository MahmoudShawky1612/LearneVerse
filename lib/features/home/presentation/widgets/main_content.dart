import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/core/providers/user_provider.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_posts.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/community_grid.dart';
import 'package:provider/provider.dart';

import '../../models/community_model.dart';
import '../../models/author_model.dart';

class MainContent extends StatelessWidget {
  MainContent({super.key});

  final List<Post> posts = Post.generateDummyPosts(15);
  final List<Community> communities = Community.generateDummyCommunities();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    
    // Get the current user from the provider
    final currentUser = Provider.of<UserProvider>(context).currentUser;
    
    // Filter communities that match user interests
    final List<Community> recommendedCommunities = communities.where((community) {
      // Check if any community tag matches user interests
      return community.tags.any((tag) => 
        currentUser.interests.any((interest) => 
          tag.toLowerCase().contains(interest.toLowerCase()) || 
          interest.toLowerCase().contains(tag.toLowerCase())
        )
      );
    }).toList();
    
    // If no matches, show some default communities
    final communitiesToShow = recommendedCommunities.isNotEmpty 
        ? recommendedCommunities 
        : communities.take(4).toList();
        
    // Filter posts that match user interests
    final List<Post> recommendedPosts = posts.where((post) {
      // Check if post tags match user interests
      bool tagMatches = post.tags.any((tag) => 
        currentUser.interests.any((interest) => 
          tag.toLowerCase().contains(interest.toLowerCase()) || 
          interest.toLowerCase().contains(tag.toLowerCase())
        )
      );
      
      // Check if post is from a community with tags matching user interests
      bool communityMatches = communities
        .where((community) => community.name == post.communityName)
        .any((community) => 
          community.tags.any((tag) => 
            currentUser.interests.any((interest) => 
              tag.toLowerCase().contains(interest.toLowerCase()) || 
              interest.toLowerCase().contains(tag.toLowerCase())
            )
          )
        );
        
      return tagMatches || communityMatches;
    }).toList();
    
    // If no matches, show all posts
    final postsToShow = recommendedPosts.isNotEmpty 
        ? recommendedPosts 
        : posts;
    
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 60, bottom: 80),
          decoration: BoxDecoration(
            gradient: themeExtension?.containerGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.onSurface.withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Recommended Communities',
                    style: textTheme.headlineSmall?.copyWith(
                      fontSize: 22, // Slightly larger for emphasis
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CommunityGrid(communities: communitiesToShow),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Posts For You',
                    style: textTheme.headlineSmall?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BuildPosts(
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  posts: postsToShow,
                  userInfo: currentUser, // Pass current user to display in posts
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
