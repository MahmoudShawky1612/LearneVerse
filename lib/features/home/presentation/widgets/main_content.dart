import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_posts.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/community_grid.dart';

import '../../models/community_model.dart';

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
    
    return Padding(
      padding: const EdgeInsets.only(top: 200.0, left: 16.0, right: 16.0),
      // Adjusted for balance
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40, bottom: 80),
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
                    'Recently Viewed Communities',
                    style: textTheme.headlineSmall?.copyWith(
                      fontSize: 22, // Slightly larger for emphasis
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CommunityGrid(communities: communities),
                const SizedBox(height: 28),
                BuildPosts(
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  posts: posts,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
