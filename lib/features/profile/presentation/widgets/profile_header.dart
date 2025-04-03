import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';

import 'profile_avatar_and_name.dart';
import 'profile_bio_quote.dart';
import 'profile_social_links_row.dart';
import 'profile_user_stats_row.dart';

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 360,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: const Icon(Icons.edit, color: AppColors.backgroundLight),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile')),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.9),
                    AppColors.primaryDark,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 16,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    ProfileAvatarAndName(),
                    const SizedBox(height: 12),
                    ProfileBioQuote(),
                    const SizedBox(height: 14),
                    Center(child: ProfileUserStatsRow()),
                    const SizedBox(height: 18),
                    ProfileSocialLinksRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
