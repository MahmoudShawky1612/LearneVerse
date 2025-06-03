import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final userInfo = widget.userInfo ?? Provider.of<UserProvider>(context).currentUser;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          ProfileHeader(userInfo: userInfo),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    color: theme.cardColor,
                    child: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: const ContributionHeader(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.onSurface.withOpacity(0.1),
                          blurRadius: 6.r,
                          spreadRadius: 0,
                          offset: Offset(0, 2.h),
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
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
          if (selectedIndex == 0)
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    UserComments(userInfo: userInfo),
                    UserPostsScreen(userInfo: userInfo),
                  ],
                ),
              ),
            )
          else if (selectedIndex == 1)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: UserJoinedCommunities(userInfo: userInfo),
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
