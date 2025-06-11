import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/profile/data/models/user_profile_model.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/profile_cubit.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/profile_state.dart';
import 'package:flutterwidgets/utils/error_state.dart';
import 'package:flutterwidgets/utils/loading_state.dart';
import 'package:flutterwidgets/utils/snackber_util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../home/data/models/community_model.dart';
import '../../logic/cubit/user_comments_cubit.dart';
import '../../logic/cubit/user_comments_states.dart';
import '../../logic/cubit/user_communities_cubit.dart';
import '../../logic/cubit/user_communities_states.dart';
import '../../logic/cubit/user_contributions_cubit.dart';
import '../../logic/cubit/user_contributions.states.dart';
import '../../logic/cubit/user_posts_cubit.dart';
import '../../logic/cubit/user_posts_states.dart';
import '../widgets/contributions.dart';
import '../widgets/no_profile_widget.dart';
import '../widgets/profile_header.dart';
import '../widgets/user_comments.dart';
import '../widgets/user_contribution_posts.dart';
import '../widgets/user_joined_communities.dart';

class ProfileScreen extends StatefulWidget {
  final userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  // Local cache for last loaded communities
  List<Community> _lastLoadedCommunities = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });

    fetchProfile();
    fetchUserPosts();
    fetchUserComments();
    fetchUserCommunities();
    fetchUserContributions();

  }

  void fetchProfile() {
    context.read<ProfileCubit>().loadProfile(widget.userId);
  }
  void fetchUserPosts() {
    context.read<UserPostCubit>().fetchPostsByUser(widget.userId);
  }
  void fetchUserComments() {
    context.read<UserCommentsCubit>().fetchCommentsByUser(widget.userId);
  }
  void fetchUserCommunities() {
    context.read<UserCommunitiesCubit>().fetchCommunitiesByUser(widget.userId);
  }
  void fetchUserContributions() {
    context.read<UserContributionsCubit>().fetchContributionsByUser(widget.userId);
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
              return const Center(child: LoadingState());
            }

           else if (state is ProfileLoaded) {
              final userInfo = state.profile;
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  ProfileHeader(userInfo: userInfo),
                  SliverPadding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.w),
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
                              padding:  EdgeInsets.all(14.w),
                              child: BlocBuilder<UserContributionsCubit, UserContributionsState>(
                                builder: (context, state) {
                                  if (state is UserContributionsLoading) {
                                    return const Center(child: LoadingState());
                                  } else if (state is UserContributionsError) {
                                    return Center(child: ErrorStateWidget(message: state.message, onRetry: fetchUserContributions));
                                  } else if (state is UserContributionsLoaded) {
                                    return ContributionChart(contributions: state.contributions);
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ),
                           SizedBox(height: 24.h),
                          // Modern Tab Selector
                          Container(
                            margin:  EdgeInsets.symmetric(horizontal: 4.w),
                            padding:  EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(30.r),
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
                            SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ],
                body: Padding(
                  padding:   EdgeInsets.symmetric(horizontal: 16.w),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      BlocBuilder<UserPostCubit, UserPostState>(
                        builder: (context, state) {
                          if (state is UserPostLoading) {
                            return const Center(child: LoadingState());
                          } else if (state is UserPostError) {
                            return Center(child: ErrorStateWidget(message: state.message, onRetry: fetchUserPosts));
                          } else if (state is UserPostLoaded) {
                            return UserPostsScreen(
                              posts: state.posts,
                              onDelete: (post) {
                                context.read<UserPostCubit>().deletePost(widget.userId, post.id);
                              },
                              onEdit: (post, updatedData) {
                                context.read<UserPostCubit>().editPost(widget.userId, post.id, updatedData);
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      BlocBuilder<UserCommentsCubit, UserCommentsState>(
                        builder: (context, state) {
                          if (state is UserCommentsLoading) {
                            return const Center(child: LoadingState());
                          } else if (state is UserCommentsError) {
                            return Center(child: ErrorStateWidget(message: state.message, onRetry: fetchUserComments));
                          } else if (state is UserCommentsLoaded) {
                            return UserComments(comments: state.comments);
                          }
                          return const SizedBox();
                        },
                      ),
                      BlocBuilder<UserCommunitiesCubit, UserCommunitiesState>(
                        builder: (context, state) {
                          if (state is UserCommunitiesLoading) {
                            return const Center(child: LoadingState());
                          } else if (state is UserCommunitiesActionError) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              SnackBarUtils.showErrorSnackBar(context, message: state.message);
                            });
                             return UserJoinedCommunities(communities: _lastLoadedCommunities, userId: widget.userId);
                          } else if (state is UserCommunitiesLoaded) {
                             _lastLoadedCommunities = state.communities;
                            return UserJoinedCommunities(communities: state.communities, userId: widget.userId);
                          } else if (state is UserCommunitiesError) {
                            return Center(child: ErrorStateWidget(message: state.message, onRetry: fetchUserCommunities));
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return   Center(
              child: noProfileDataWidget()
            );
          },
        ),
      ),
    );
  }
}