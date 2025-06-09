import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/user_posts_states.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterwidgets/features/profile/data/models/user_profile_model.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/profile_cubit.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/profile_state.dart';
import '../../logic/cubit/user_comments_cubit.dart';
import '../../logic/cubit/user_comments_states.dart';
import '../../logic/cubit/user_communities_cubit.dart';
import '../../logic/cubit/user_communities_states.dart';
import '../../logic/cubit/user_posts_cubit.dart';
import '../widgets/contributions.dart';
import '../widgets/profile_header.dart';
import '../widgets/user_contribution_comments.dart';
import '../widgets/user_contribution_posts.dart';
import '../widgets/user_joined_communities.dart';

class ProfileScreen extends StatefulWidget {
  final  userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
      print('Current idddddddddddddddddddddddddddd index: ${widget.userId}');
    });

    context.read<ProfileCubit>().loadProfile(widget.userId);
    context.read<UserPostCubit>().fetchPostsByUser(widget.userId);
    context.read<UserCommentsCubit>().fetchCommentsByUser(widget.userId);
    context.read<UserCommunitiesCubit>().fetchCommunitiesByUser(widget.userId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildModernTab({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
          colors: [
            Colors.purple.shade400,
            Colors.purple.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: isSelected ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(isSelected ? 6 : 5),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FaIcon(
              icon,
              size: isSelected ? 14 : 12,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          if (isSelected) ...[
            const SizedBox(width: 6),
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ],
      ),
    );
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

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
                          const SizedBox(height: 24),
                          // Modern Tab Selector
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: colorScheme.outline.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.shadow.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      _tabController.animateTo(0);
                                    },
                                    child: _buildModernTab(
                                      icon: FontAwesomeIcons.solidPenToSquare,
                                      label: 'Posts',
                                      index: 0,
                                      isSelected: _currentIndex == 0,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      _tabController.animateTo(1);
                                    },
                                    child: _buildModernTab(
                                      icon: FontAwesomeIcons.solidCommentDots,
                                      label: 'Comments',
                                      index: 1,
                                      isSelected: _currentIndex == 1,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      _tabController.animateTo(2);
                                    },
                                    child: _buildModernTab(
                                      icon: FontAwesomeIcons.peopleGroup,
                                      label: 'Communities',
                                      index: 2,
                                      isSelected: _currentIndex == 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      BlocBuilder<UserPostCubit, UserPostState>(
                        builder: (BuildContext context, UserPostState state) {
                          if (state is UserPostLoading) {
                            return const Center(child: CupertinoActivityIndicator());
                          } else if (state is UserPostError) {
                            return Center(child: Text(state.message));
                          } else if (state is UserPostLoaded) {
                            return UserPostsScreen(posts: state.posts);
                          }
                          return const SizedBox();
                        },
                      ),
                      BlocBuilder<UserCommentsCubit, UserCommentsState>(
                        builder: (BuildContext context, UserCommentsState state) {
                          if (state is UserCommentsLoading) {
                            return const Center(child: CupertinoActivityIndicator());
                          } else if (state is UserCommentsError) {
                            return Center(child: Text(state.message));
                          } else if (state is UserCommentsLoaded) {
                            return UserComments(comments: state.comments);
                          }
                          return const SizedBox();
                        },
                      ),
                      BlocBuilder<UserCommunitiesCubit, UserCommunitiesState>(
                        builder: (BuildContext context, UserCommunitiesState state) {
                          if (state is UserCommunitiesLoading) {
                            return const Center(child: CupertinoActivityIndicator());
                          } else if (state is UserCommunitiesError) {
                            return Center(child: Text(state.message));
                          } else if (state is UserCommunitiesLoaded) {
                            return UserJoinedCommunities(communities: state.communities);
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox(); // initial or fallback
          },
        ),
      ),
    );
  }
}