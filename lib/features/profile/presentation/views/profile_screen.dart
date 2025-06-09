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
  final int userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile(widget.userId);
    context.read<UserPostCubit>().fetchPostsByUser(widget.userId);
    context.read<UserCommentsCubit>().fetchCommentsByUser(widget.userId);
    context.read<UserCommunitiesCubit>().fetchCommunitiesByUser(widget.userId);
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

              return DefaultTabController(
                length: 3,
                child: NestedScrollView(
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
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.onSurface.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const TabBar(
                                labelColor: Colors.black,
                                indicatorColor: Colors.deepOrange,
                                tabs: [
                                  Tab(
                                    icon: FaIcon(FontAwesomeIcons.solidPenToSquare),
                                    text: 'Posts',
                                  ),
                                  Tab(
                                    icon: FaIcon(FontAwesomeIcons.solidCommentDots),
                                    text: 'Comments',
                                  ),
                                  Tab(
                                    icon: FaIcon(FontAwesomeIcons.peopleGroup),
                                    text: 'Communities',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBarView(
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