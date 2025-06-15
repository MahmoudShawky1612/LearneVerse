import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/community/service/forum_service.dart';
import 'package:flutterwidgets/features/community/views/widgets/classroom_tab.dart';
import 'package:flutterwidgets/features/community/views/widgets/community_header.dart';
import 'package:flutterwidgets/features/community/views/widgets/forum_tab.dart';
import 'package:flutterwidgets/features/community/views/widgets/info_tab.dart';
import 'package:flutterwidgets/features/community/views/widgets/join_button.dart';
import 'package:flutterwidgets/features/community/views/widgets/leaderboard_tab.dart';
import 'package:flutterwidgets/features/community/views/widgets/members_tab.dart';
import 'package:flutterwidgets/features/community/views/widgets/quizzes_tab.dart';
import 'package:flutterwidgets/features/community/views/widgets/sliver_app_bar.dart';
import 'package:flutterwidgets/features/community/views/widgets/tab_selector.dart';
import 'package:flutterwidgets/features/profile/views/widgets/no_profile_widget.dart';
import 'package:flutterwidgets/utils/error_state.dart';
import 'package:flutterwidgets/utils/jwt_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../../utils/loading_state.dart';
import '../../../../utils/snackber_util.dart';
import '../../../../utils/token_storage.dart';
import '../../home/data/models/community_model.dart';
import '../../quizzes/logic/cubit/quiz_cubit.dart';
import '../../quizzes/service/quiz_service.dart';
import '../logic/cubit/join_requests_cubit.dart';
import '../logic/cubit/join_requests_states.dart';
import '../logic/cubit/single_community_cubit.dart';
import '../logic/cubit/single_community_states.dart';
import '../service/join_requests_service.dart';

class CommunityScreen extends StatefulWidget {
  final Community community;

  const CommunityScreen({super.key, required this.community});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _currentIndex = 0;
  bool _isJoinButtonDisabled = false;

  bool get _showJoinRequestsTab =>
      _userRole == 'OWNER' || _userRole == 'MODERATOR';
  String? _userRole;

  final TextEditingController _searchController = TextEditingController();
  VideoPlayerController? _videoController;

  // Track loading state for each request
  int? _loadingRequestId;

  static const String _joinRequestPrefixKey = 'join_request_';

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  void _initializeScreen() {
    _fetchCommunityData();
    _loadJoinButtonState();
    _searchController.clear();
  }

  void _fetchCommunityData() {
    context
        .read<SingleCommunityCubit>()
        .fetchSingleCommunity(widget.community.id);
    context
        .read<CommunityRoleCubit>()
        .fetchUserRole(widget.community.id)
        .then((_) {
      final state = context.read<CommunityRoleCubit>().state;
      if (state is CommunityRoleLoaded) {
        setState(() {
          _userRole = state.role;
        });
      }
    });
  }

  void _disposeResources() {
    _searchController.dispose();
    _videoController?.dispose();
  }

  Future<void> _loadJoinButtonState() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getJoinRequestKeyWithUser();
    if (mounted) {
      setState(() {
        _isJoinButtonDisabled = prefs.getBool(key) ?? false;
      });
    }
  }

  Future<int> getIdFromToken() async {
    final token = await TokenStorage.getToken();
    return getUserIdFromToken(token!);
  }

  Future<void> _saveJoinButtonState(bool isDisabled) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getJoinRequestKeyWithUser();
    await prefs.setBool(key, isDisabled);
  }

  void _clearJoinButtonState() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getJoinRequestKeyWithUser();
    await prefs.remove(key);
  }

  Future<String> _getJoinRequestKeyWithUser() async {
    final userId = await getIdFromToken();
    return '$_joinRequestPrefixKey${widget.community.id}_$userId';
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _joinCommunity() async {
    try {
      context.read<CommunityRoleCubit>().joinCommunity(widget.community.id);

      setState(() {
        _isJoinButtonDisabled = true;
      });

      await _saveJoinButtonState(true);

      if (mounted) {
        if (widget.community.isPublic) {
          SnackBarUtils.showSuccessSnackBar(
            context,
            message: '👋 🎉 Welcome to ${widget.community.name}!',
          );
          _clearJoinButtonState();
        } else {
          SnackBarUtils.showInfoSnackBar(
            context,
            message: '✍️Join request sent!.',
            duration: const Duration(seconds: 4),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
          context,
          message: 'Failed to join community. Please try again.',
          actionLabel: 'Retry',
          onActionPressed: () {
            setState(() {
              _isJoinButtonDisabled = false;
            });
            _saveJoinButtonState(false);
          },
        );
      }
    }
  }

  Widget _buildJoinButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: ModernButton(
        text: 'Join Community',
        disabledText: widget.community.isPublic ? 'Joined!' : 'Request Sent',
        onPressed: _joinCommunity,
        style: widget.community.isPublic
            ? ModernButtonStyle.success
            : ModernButtonStyle.primary,
        size: ModernButtonSize.large,
        icon: widget.community.isPublic ? Icons.group_add : Icons.send,
        width: double.infinity,
        isDisabled: _isJoinButtonDisabled,
      ),
    );
  }

  Widget _buildTabContent(Community community, bool hasJoined) {
    if (!hasJoined) {
      return InfoTab(
        community: community,
        formatDuration: formatDuration,
        onJoinToggle: _joinCommunity,
      );
    }

    // Adjust tab index for join requests tab
    final joinRequestsTabIndex = _showJoinRequestsTab ? 5 : -1;

    switch (_currentIndex) {
      case 0:
        return InfoTab(
          community: community,
          formatDuration: formatDuration,
          onJoinToggle: _joinCommunity,
        );
      case 1:
        return ClassroomTab(community: community);
      case 2:
        return BlocProvider(
          create: (context) => QuizCubit(QuizService()),
          child: QuizzesTab(community: community),
        );
      case 3:
        return RepositoryProvider(
          create: (BuildContext context) => ForumApiService(),
          child: ForumTab(
            community: community,
          ),
        );
      case 4:
        return LeaderboardTab(communityId: widget.community.id);
      case 5:
        return MembersTab(
          community: community,
        );
      case 6:
        if (_showJoinRequestsTab) {
          return BlocProvider(
            create: (context) => JoinRequestsCubit(ApiService())
              ..fetchJoinRequests(widget.community.id),
            child: BlocBuilder<JoinRequestsCubit, JoinRequestsState>(
              builder: (context, state) {
                if (state is JoinRequestsLoading) {
                  return const Center(child: LoadingState());
                } else if (state is JoinRequestsLoaded) {
                  final requests = state.requests;
                  if (requests.isEmpty) {
                    return Center(
                        child: Column(
                      children: [
                        NoDataWidget(
                          message: 'Looks like no one wanna join ATM 😕',
                          width: 100.w,
                          height: 100.h,
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final req = requests[index];
                      final user = req['User'];
                      final profileUrl = user['UserProfile'] != null
                          ? user['UserProfile']['profilePictureURL']
                          : '';
                      final isLoading = _loadingRequestId == req['id'];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors
                              .grey[200], // Optional: Set a background color
                          radius: 20, // Optional: Adjust the size of the avatar
                          child: profileUrl == null || profileUrl.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                  size: 28,
                                )
                              : ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: profileUrl,
                                    fit: BoxFit.cover,
                                    width: 40,
                                    // Adjust to match CircleAvatar size
                                    height: 40,
                                    placeholder: (context, url) => SizedBox(
                                      width: 28.r,
                                      height: 28.r,
                                      child: const CupertinoActivityIndicator(),
                                    ),
                                    errorWidget: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        color: Colors.blue,
                                        size: 28,
                                      );
                                    },
                                  ),
                                ),
                        ),
                        title: Text(user['fullname'] ?? ''),
                        subtitle: Text('@${user['username']}' ?? ''),
                        trailing: isLoading
                            ? const SizedBox(
                                width: 60,
                                child: Center(
                                    child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CupertinoActivityIndicator())))
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(FontAwesomeIcons.check,
                                        color: Colors.green),
                                    onPressed: () async {
                                      setState(
                                          () => _loadingRequestId = req['id']);
                                      await context
                                          .read<JoinRequestsCubit>()
                                          .updateRequestStatus(
                                            req['id'],
                                            'APPROVED',
                                            widget.community.id,
                                          );
                                      setState(() => _loadingRequestId = null);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(FontAwesomeIcons.xmark,
                                        color: Colors.red),
                                    onPressed: () async {
                                      setState(
                                          () => _loadingRequestId = req['id']);
                                      await context
                                          .read<JoinRequestsCubit>()
                                          .updateRequestStatus(
                                            req['id'],
                                            'REJECTED',
                                            widget.community.id,
                                          );
                                      setState(() => _loadingRequestId = null);
                                    },
                                  ),
                                ],
                              ),
                      );
                    },
                  );
                } else if (state is JoinRequestsError) {
                  return Center(
                      child: ErrorStateWidget(
                    message: state.message,
                    onRetry: () {
                      context
                          .read<JoinRequestsCubit>()
                          .fetchJoinRequests(widget.community.id);
                    },
                  ));
                }
                return const SizedBox.shrink();
              },
            ),
          );
        }
        return InfoTab(
          community: community,
          formatDuration: formatDuration,
          onJoinToggle: _joinCommunity,
        );
      default:
        return InfoTab(
          community: community,
          formatDuration: formatDuration,
          onJoinToggle: _joinCommunity,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CommunityRoleCubit, CommunityRoleState>(
        builder: (context, roleState) {
          if (roleState is CommunityRoleLoading) {
            return const LoadingState();
          }

          if (roleState is CommunityRoleError) {
            return ErrorStateWidget(
                message: roleState.message, onRetry: _fetchCommunityData);
          }

          if (roleState is CommunityRoleLoaded) {
            final hasJoined = roleState.role != null;

            if (hasJoined && _isJoinButtonDisabled) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isJoinButtonDisabled = false;
                });
                _clearJoinButtonState();
              });
            }

            return BlocBuilder<SingleCommunityCubit, SingleCommunityStates>(
              builder: (context, communityState) {
                if (communityState is SingleCommunityLoading) {
                  return const LoadingState();
                }

                if (communityState is SingleCommunityFailure) {
                  return ErrorStateWidget(
                      message: communityState.message,
                      onRetry: _fetchCommunityData);
                }

                if (communityState is SingleCommunitySuccess) {
                  final community = communityState.community;

                  return CustomScrollView(
                    slivers: [
                      CommunitySliverAppBar(community: community),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommunityHeader(community: community),
                              SizedBox(height: 16.h),
                              if (!hasJoined)
                                _buildJoinButton()
                              else if (community.isPublic || hasJoined)
                                TabSelector(
                                  currentIndex: _currentIndex,
                                  onTabSelected: (index) {
                                    setState(() => _currentIndex = index);
                                  },
                                  showJoinRequestsTab: _showJoinRequestsTab,
                                ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        sliver: SliverToBoxAdapter(
                          child: _buildTabContent(community, hasJoined),
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
