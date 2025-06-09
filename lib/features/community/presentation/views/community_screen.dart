import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/community/services/forum_service.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../../utils/snackber_util.dart';
import '../../../home/data/models/community_model.dart';
import '../../logic/cubit/join_requests_cubit.dart';
import '../../logic/cubit/join_requests_states.dart';
import '../../logic/cubit/single_community_cubit.dart';
import '../../logic/cubit/single_community_states.dart';
import '../widgets/classroom_tab.dart';
import '../widgets/community_header.dart';
import '../widgets/forum_tab.dart';
import '../widgets/info_tab.dart';
import '../widgets/join_button.dart';
import '../widgets/leaderboard_tab.dart';
import '../widgets/members_tab.dart';
import '../widgets/sliver_app_bar.dart';
import '../widgets/tab_selector.dart';


class CommunityScreen extends StatefulWidget {
  final Community community;

  const CommunityScreen({super.key, required this.community});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // UI State
  int _currentIndex = 0;
  bool _isJoinButtonDisabled = false;

  // Controllers
  final TextEditingController _searchController = TextEditingController();
  VideoPlayerController? _videoController;

  // Data
  late final List<Post> _posts;
  late final List<Author> _members;
  late final List<Author> _foundUsers;
  File? _selectedImage;

  // Constants
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

  // Initialization Methods
  void _initializeScreen() {
    _fetchCommunityData();
    _loadJoinButtonState();
    _searchController.clear();
  }

  void _fetchCommunityData() {
    context.read<SingleCommunityCubit>().fetchSingleCommunity(widget.community.id);
    context.read<CommunityRoleCubit>().fetchUserRole(widget.community.id);
  }

  void _disposeResources() {
    _searchController.dispose();
    _videoController?.dispose();
  }

  // SharedPreferences Methods
  Future<void> _loadJoinButtonState() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isJoinButtonDisabled = prefs.getBool(_getJoinRequestKey()) ?? false;
      });
    }
  }

  Future<void> _saveJoinButtonState(bool isDisabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_getJoinRequestKey(), isDisabled);
  }

  String _getJoinRequestKey() => '$_joinRequestPrefixKey${widget.community.id}';

  // Utility Methods
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _searchUsers(String query) {
    setState(() {
      _foundUsers = Author.searchUsers(query);
    });
  }

  // Image Picker
  Future<void> _selectImage() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null && mounted) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });

        SnackBarUtils.showSuccessSnackBar(
          context,
          message: 'Image selected successfully!',
        );
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
          context,
          message: 'Failed to select image. Please try again.',
        );
      }
    }
  }

  // Community Actions
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

  void _createNewPost() {
    // Implementation for creating new post
    SnackBarUtils.showInfoSnackBar(
      context,
      message: 'Post creation feature coming soon!',
    );
  }

  // UI Builders
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
        return RepositoryProvider(
          create: (BuildContext context) => ForumApiService(),
          child: ForumTab(
             community: community,
           ),
        );
      case 3:
        return LeaderboardTab(members: _members);
      case 4:
        return MembersTab(
          community: community,
          searchController: _searchController,
          onSearch: _searchUsers,
        );
      default:
        return InfoTab(
          community: community,
          formatDuration: formatDuration,
          onJoinToggle: _joinCommunity,
        );
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.sp,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ModernButton(
            text: 'Try Again',
            onPressed: () => _fetchCommunityData(),
            style: ModernButtonStyle.outline,
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CommunityRoleCubit, CommunityRoleState>(
        builder: (context, roleState) {
          if (roleState is CommunityRoleLoading) {
            return _buildLoadingState();
          }

          if (roleState is CommunityRoleError) {
            return _buildErrorState(roleState.message);
          }

          if (roleState is CommunityRoleLoaded) {
            final hasJoined = roleState.role != null;

            // Reset button state if user has joined
            if (hasJoined && _isJoinButtonDisabled) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isJoinButtonDisabled = false;
                });
                _saveJoinButtonState(false);
              });
            }

            return BlocBuilder<SingleCommunityCubit, SingleCommunityStates>(
              builder: (context, communityState) {
                if (communityState is SingleCommunityLoading) {
                  return _buildLoadingState();
                }

                if (communityState is SingleCommunityFailure) {
                  return _buildErrorState(communityState.message);
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

                              // Show join button if user hasn't joined
                              if (!hasJoined)
                                _buildJoinButton()
                              // Show tabs if user has joined or community is public
                              else if (community.isPublic || hasJoined)
                                TabSelector(
                                  currentIndex: _currentIndex,
                                  onTabSelected: (index) {
                                    setState(() => _currentIndex = index);
                                  },
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

