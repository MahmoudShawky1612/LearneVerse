import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import '../widgets/contribution_header.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tab_button.dart';
import '../widgets/user_contribution_comments.dart';
import '../widgets/user_contribution_posts.dart';
import '../widgets/user_joined_communities.dart';

class ProfileScreen extends StatefulWidget {
  final userInfo;
  const ProfileScreen({super.key, this.userInfo});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          ProfileHeader(userInfo:widget.userInfo),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: AppColors.surfaceLight,
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: ContributionHeader(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textSecondary.withOpacity(0.1),
                          blurRadius: 6,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ProfileTabButton(
                            title: "Contributions",
                            index: 0,
                            icon: Icons.edit_note,
                            selectedIndex: selectedIndex,
                            onTap: (index) =>
                                setState(() => selectedIndex = index),
                          ),
                        ),
                        Expanded(
                          child: ProfileTabButton(
                            title: "Communities",
                            index: 1,
                            icon: Icons.people,
                            selectedIndex: selectedIndex,
                            onTap: (index) =>
                                setState(() => selectedIndex = index),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (selectedIndex == 0)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    UserComments(),
                    UserPostsScreen(),
                  ],
                ),
              ),
            )
          else if (selectedIndex == 1)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: UserJoinedCommunities(),
              ),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}
