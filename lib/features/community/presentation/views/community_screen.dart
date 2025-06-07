import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../home/data/models/community_model.dart';
import '../../logic/cubit/single_community_cubit.dart';
import '../../logic/cubit/single_community_states.dart';
import '../widgets/classroom_tab.dart';
import '../widgets/community_header.dart';
import '../widgets/forum_tab.dart';
import '../widgets/info_tab.dart';
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
  int _currentIndex = 0;
  late final List<Post> _posts;
  late final List<Author> _members;
  late bool _userHasJoined;
  late Author _currentUser;
  late Author first;
  late Author second;
  late Author third;
  late List<Author> foundUsers;
  TextEditingController searchController = TextEditingController();
  File? _image;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    context.read<SingleCommunityCubit>().fetchSingleCommunity(widget.community.id);

    _posts = Post.generateDummyPosts(15);
    _members = Author.generateMoreDummyAuthors();
    _currentUser = Author.users[0];
    foundUsers = [];
    searchController.clear();
  }

  @override
  void dispose() {
    searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void searchUsers(String query) {
    setState(() {
      foundUsers = Author.searchUsers(query);
    });
  }

  Future<void> imagePicker() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() => _image = File(pickedImage.path));
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _createNewPost() {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleCommunityCubit, SingleCommunityStates>(
      builder: (context, state) {
        if (state is SingleCommunityLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is SingleCommunityFailure) {
          return Center(child: Text("Error: ${state.message}"));
        } else if (state is SingleCommunitySuccess) {
          _userHasJoined = _currentUser.joinedCommunities.any((c) => c.id == state.community.id);
          return Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                CommunitySliverAppBar(community: state.community),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CommunityHeader(community: state.community),
                        SizedBox(height: 24.h),
                        if (state.community.isPublic || _userHasJoined)
                          TabSelector(
                            currentIndex: _currentIndex,
                            onTabSelected: (index) => setState(() => _currentIndex = index),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  sliver: SliverToBoxAdapter(
                    child: _buildSelectedScreen(state.community),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildSelectedScreen(Community community) {
    switch (_currentIndex) {
      case 0:
        return InfoTab(
          community: community,
          formatDuration: _formatDuration,
          userHasJoined: _userHasJoined,
          onJoinToggle: () => setState(() => _userHasJoined = !_userHasJoined),
        );
      case 1:
        return ClassroomTab(community: community);
      case 2:
        return ForumTab(
          posts: _posts,
          onCreatePost: _createNewPost,
          community: community,
          currentUser: _currentUser,
          imagePicker: imagePicker,
        );
      case 3:
        return LeaderboardTab(members: _members);
      case 4:
        return MembersTab(
          community: community,
          members: _members,
          foundUsers: foundUsers,
          searchController: searchController,
          onSearch: searchUsers,
        );
      default:
        return InfoTab(
          community: community,
          formatDuration: _formatDuration,
          userHasJoined: _userHasJoined,
          onJoinToggle: () => setState(() => _userHasJoined = !_userHasJoined),
        );
    }
  }
}
