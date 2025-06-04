import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_posts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../discover/presentation/widgets/vertical_users_list.dart';

class CommunityScreen extends StatefulWidget {
  final dynamic community;

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
  late final Author first;
  late final Author second;
  late final Author third;
  late List<Author> foundUsers;
  TextEditingController searchController = TextEditingController();
  File? _image;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _posts = Post.generateDummyPosts(15);
    _members = Author.generateMoreDummyAuthors();
    _currentUser = Author.users[0];
    _userHasJoined = _checkIfUserJoined();

    first = _members[0];
    second = _members[1];
    third = _members[2];
    foundUsers = [];
    searchController.clear();

    _controller = VideoPlayerController.asset(widget.community.introVideo)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
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

  bool _checkIfUserJoined() {
    return _currentUser.joinedCommunities
        .any((community) => community.id == widget.community.id);
  }

  Future<void> imagePicker() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildCommunityHeader(),
                  SizedBox(height: 24.h),
                  if (widget.community.communityPrivacy == "Public" ||
                      _userHasJoined)
                    _buildTabSelector(),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            sliver: SliverToBoxAdapter(
              child: _buildSelectedScreen(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 400.0.h,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              widget.community.communityBackgroundImage,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          widget.community.name,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCommunityHeader() {
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    final theme = Theme.of(context);

    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 40.r,
          backgroundImage: AssetImage(widget.community.image),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.community.name,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.people,
                    size: 16.w,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${widget.community.memberCount} members',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    widget.community.communityPrivacy == "Public"
                        ? Icons.lock_open
                        : Icons.lock,
                    size: 16,
                    color: widget.community.communityPrivacy == "Public"
                        ? themeExtension?.upVote
                        : themeExtension?.downVote,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    widget.community.communityPrivacy,
                    style: TextStyle(
                      color: widget.community.communityPrivacy == "Public"
                          ? themeExtension?.upVote
                          : themeExtension?.downVote,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: <Widget>[
                  _buildRatingStars(),
                  SizedBox(width: 8.w),
                  Text(
                    '(${widget.community.reviews} reviews)',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (index) {
        return Icon(
          index < widget.community.rating.floor()
              ? Icons.star
              : (index == widget.community.rating.floor() &&
                      widget.community.rating % 1 > 0)
                  ? Icons.star_half
                  : Icons.star_border,
          color: Colors.amber,
          size: 18.w,
        );
      }),
    );
  }

  Widget _buildTabSelector() {
    final List<String> tabs = [
      'Info',
      'Classroom',
      'Forum',
      'Leaderboard',
      'Members',
    ];

    return SizedBox(
      height: 50.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          return _buildTabItem(tabs[index], index);
        },
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        margin: EdgeInsets.only(right: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        decoration: BoxDecoration(
          gradient: isSelected ? themeExtension?.buttonGradient : null,
          color: isSelected ? null : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedScreen() {
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    switch (_currentIndex) {
      case 0:
        return _buildInfoTab();
      case 1:
        return _buildClassroomTab();
      case 2:
        return _buildForumTab();
      case 3:
        return _buildLeaderboardTab();
      case 4:
        return _buildMembersTab();
      default:
        return _buildInfoTab();
    }
  }

  Widget _buildInfoTab() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Text(
          'About this Community',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'This is a community where members can learn, share, and grow together. Join us to access exclusive content, participate in discussions, and connect with like-minded individuals.',
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5.h,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Tags',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.w,
          children: List<Widget>.from(widget.community.tags.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: theme.colorScheme.surface,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
            );
          })),
        ),
        SizedBox(height: 24.h),
        Text(
          "Intro video to ${widget.community.name}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.w),
        ),
        SizedBox(height: 10.h),
        if (_controller.value.isInitialized)
          Column(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              Slider(
                  value: _controller.value.position.inSeconds.toDouble(),
                  min: 0,
                  max: _controller.value.duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _controller.seekTo(Duration(seconds: value.toInt()));
                    });
                  }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_controller.value.position)),
                    Text(_formatDuration(_controller.value.duration)),
                  ],
                ),
              ),
            ],
          )
        else
          const CircularProgressIndicator(),
        SizedBox(height: 24.h),
        Center(
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Community Guidelines',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        _buildGuideline(
          icon: Icons.check_circle_outline,
          title: 'Be Respectful',
          description: 'Treat others with kindness and respect.',
        ),
        _buildGuideline(
          icon: Icons.check_circle_outline,
          title: 'Share Knowledge',
          description: 'Contribute valuable content to the community.',
        ),
        _buildGuideline(
          icon: Icons.check_circle_outline,
          title: 'Stay On Topic',
          description: 'Keep discussions relevant to the community focus.',
        ),
        SizedBox(height: 24.h),
        if (!_userHasJoined)
          SizedBox(
            width: double.infinity,
            child: _buildJoinButton(),
          ),
        SizedBox(height: 36.h),
      ],
    );
  }

  Widget _buildGuideline({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            color: colorScheme.primary,
            size: 20.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButton() {
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _userHasJoined = !_userHasJoined;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.w),
        decoration: BoxDecoration(
          gradient: themeExtension?.buttonGradient,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            _userHasJoined ? 'Leave Community' : 'Join Community',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassroomTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> sections = [
      {
        'title': 'Introduction to the Community',
        'lessons': 3,
        'completed': 2,
        'duration': '45 minutes',
        'image': widget.community.communityBackgroundImage,
      },
      {
        'title': 'Getting Started with Projects',
        'lessons': 5,
        'completed': 0,
        'duration': '1.5 hours',
        'image': widget.community.communityBackgroundImage,
      },
      {
        'title': 'Advanced Techniques',
        'lessons': 8,
        'completed': 0,
        'duration': '3 hours',
        'image': widget.community.communityBackgroundImage,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Learning Sections',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...sections.map((section) => _buildSectionCard(section)),
        SizedBox(height: 24.h),
        SizedBox(height: 36.h),
      ],
    );
  }

  Widget _buildSectionCard(Map<String, dynamic> section) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    section['image'] as String,
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        section['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: <Widget>[
                          _buildInfoChip(
                            Icons.book,
                            '${section['lessons']} lessons',
                          ),
                          SizedBox(width: 8.w),
                          _buildInfoChip(
                            Icons.access_time,
                            section['duration'] as String,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      LinearProgressIndicator(
                        value: (section['completed'] as int) /
                            (section['lessons'] as int),
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${section['completed']}/${section['lessons']} completed',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16.w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            size: 14.w,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForumTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Community Forum',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _showCreatePostDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text('New Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: BuildPosts(
            scrollPhysics: const NeverScrollableScrollPhysics(),
            posts: _posts,
          ),
        ),
      ],
    );
  }

  void _showCreatePostDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final currentUser = Author.users[0]; 
    final currentCommunity = widget.community;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final themeExtension = theme.extension<AppThemeExtension>();

        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(currentUser.avatar),
                radius: 16.r,
              ),
              SizedBox(width: 10.w),
              Text(
                'Create Post',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: theme.hintColor),
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor ??
                        theme.scaffoldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: descriptionController,
                  style: TextStyle(color: colorScheme.onSurface),
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: theme.hintColor),
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor ??
                        theme.scaffoldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: imagePicker,
                    icon: const Icon(Icons.image_outlined)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: themeExtension?.buttonGradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    _createNewPost(
                        titleController.text,
                        descriptionController.text,
                        currentUser,
                        currentCommunity);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Post',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _createNewPost(
      String title, String description, Author author, Community community) {
    final newPost = Post(
      title: title,
      description: description,
      voteCount: 0,
      upvote: 0,
      downVote: 0,
      author: author.name,
      avatar: author.avatar,
      time: 0,
      commentCount: 0,
      communityName: community.name,
      communityImage: community.image,
      tags: [],
      id: '${_posts.length}',
      image: _image,
    );

    setState(() {
      _posts.insert(0, newPost); 
    });
  }

  Widget _buildLeaderboardTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Text(
          'Top Contributors',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 24.h),

        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            
            _buildPodiumItem(
              _members[1],
              2,
              height: 120.h,
              theme: theme,
              colorScheme: colorScheme,
              themeExtension: themeExtension,
            ),
            SizedBox(width: 12.w),

            
            _buildPodiumItem(
              _members[0],
              1,
              height: 150.h,
              theme: theme,
              colorScheme: colorScheme,
              themeExtension: themeExtension,
              isFirst: true,
            ),
            SizedBox(width: 12.w),

            
            _buildPodiumItem(
              _members[2],
              3,
              height: 100.h,
              theme: theme,
              colorScheme: colorScheme,
              themeExtension: themeExtension,
            ),
          ],
        ),

        SizedBox(height: 32.h),

        
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: <Widget>[
                    const Text(
                      'Rank',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 24.w),
                    const Expanded(
                      child: Text(
                        'User',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      'Points',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1.h),
              ...List.generate(
                7,
                (index) => _buildTopMemberItem(
                  rank: index + 4,
                  name: _members[index + 3].name,
                  username: _members[index + 3].userName,
                  avatarUrl: _members[index + 3].avatar,
                  points: _members[index + 3].points,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumItem(
    dynamic user,
    int rank, {
    required double height,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required themeExtension,
    bool isFirst = false,
  }) {
    Color medalColor;
    switch (rank) {
      case 1:
        medalColor = const Color(0xFFFFD700); 
        break;
      case 2:
        medalColor = const Color(0xFFC0C0C0); 
        break;
      case 3:
        medalColor = const Color(0xFFCD7F32); 
        break;
      default:
        medalColor = colorScheme.primary;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: medalColor, width: 3.w),
            boxShadow: [
              BoxShadow(
                color: medalColor.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              user.avatar,
              width: 60.w,
              height: 60.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        
        Text(
          user.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isFirst ? 16.sp : 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
          decoration: BoxDecoration(
            color: medalColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: medalColor.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${user.points} pts',
            style: TextStyle(
              color: medalColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        
        Stack(
          alignment: Alignment.center,
          children: [
            
            Container(
              width: 80,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    medalColor.withOpacity(0.7),
                    medalColor.withOpacity(0.4),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: medalColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: medalColor.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: medalColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopMemberItem({
    required int rank,
    required String name,
    required String username,
    required String avatarUrl,
    required int points,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5.w,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(
            '$rank',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: rank <= 3 ? colorScheme.primary : null,
            ),
          ),
          SizedBox(width: 24.w),
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: themeExtension?.circleGradient,
            ),
            child: ClipOval(
              child: Image.asset(
                avatarUrl,
                width: 36.w,
                height: 36.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '@$username',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$points pts',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'All Members',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${widget.community.memberCount} members',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            onChanged: searchUsers,
            decoration: InputDecoration(
              hintText: 'Search members...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: foundUsers.isEmpty
              ? VerticalUserList(users: _members)
              : VerticalUserList(users: foundUsers),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
