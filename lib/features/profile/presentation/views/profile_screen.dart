import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/profile/data/models/user_profile_model.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/profile_cubit.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/profile_state.dart';

import '../widgets/contributions.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tab_button.dart';
import '../widgets/user_contribution_comments.dart';
import '../widgets/user_contribution_posts.dart';
import '../widgets/user_joined_communities.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
print(widget.userId);    context.read<ProfileCubit>().loadProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
      
            if (state is ProfileError) {
              return Center(child: Text(state.message));
            }
      
            if (state is ProfileLoaded) {
              final UserProfile userInfo = state.profile;
      
              return CustomScrollView(
                slivers: [
                  ProfileHeader(userInfo: userInfo),
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
                            color: theme.cardColor,
                            child: const Padding(
                              padding: EdgeInsets.all(14),
                              child: ContributionChart(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  colorScheme.onSurface.withOpacity(0.1),
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
                            UserComments(userInfo: userInfo),
                            UserPostsScreen(userInfo: userInfo),
                          ],
                        ),
                      ),
                    )
                  else if (selectedIndex == 1)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: UserJoinedCommunities(userInfo: userInfo),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              );
            }
      
            return const SizedBox(); // initial or fallback
          },
        ),
      ),
    );
  }
}
