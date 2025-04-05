import 'package:flutter/material.dart';

import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import 'package:flutterwidgets/features/home/models/post_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_posts.dart';
import 'package:flutterwidgets/features/profile/presentation/views/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../discover/presentation/widgets/vertical_users_list.dart';
import '../../../home/models/author_model.dart';
import '../../../home/models/post_model.dart';
import '../../../home/presentation/widgets/build_posts.dart';

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

  @override
  void initState() {
    super.initState();
    _posts = Post.generateDummyPosts(15);
    _members = Author.generateMoreDummyAuthors();
    // Assume the first user is the current user
    _currentUser = Author.users[0];
    // Check if user has joined this community
    _userHasJoined = _checkIfUserJoined();

    first = _members[0];
    second = _members[1];
    third = _members[2];
    foundUsers = [];
    searchController.clear();
  }

  @override
  void dispose() {
    searchController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildCommunityHeader(),
                  const SizedBox(height: 24),
                  // Only show tab selector if community is public or user has joined
                  if (widget.community.communityPrivacy == "Public" ||
                      _userHasJoined)
                    _buildTabSelector(),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
      expandedHeight: 400.0,
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
    final colorScheme = theme.colorScheme;
    
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(widget.community.image),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.community.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.people,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.community.memberCount} members',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    widget.community.communityPrivacy == "Public"
                        ? Icons.lock_open
                        : Icons.lock,
                    size: 16,
                    color: widget.community.communityPrivacy == "Public"
                        ? themeExtension?.upVote
                        : themeExtension?.downVote,
                  ),
                  const SizedBox(width: 4),
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
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  _buildRatingStars(),
                  const SizedBox(width: 8),
                  Text(
                    '(${widget.community.reviews} reviews)',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
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
          size: 18,
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
      height: 50,
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
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? themeExtension?.buttonGradient : null,
          color: isSelected ? null : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
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
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 24),
        const Text(
          'About this Community',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'This is a community where members can learn, share, and grow together. Join us to access exclusive content, participate in discussions, and connect with like-minded individuals.',
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List<Widget>.from(widget.community.tags.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: theme.colorScheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            );
          })),
        ),
        const SizedBox(height: 24),
        const Text(
          'Community Guidelines',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 24),
        if (!_userHasJoined)
          SizedBox(
            width: double.infinity,
            child: _buildJoinButton(),
          ),
        const SizedBox(height: 36),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            color: colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
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
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: themeExtension?.buttonGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            _userHasJoined ? 'Leave Community' : 'Join Community',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
        const SizedBox(height: 24),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Learning Sections',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...sections.map((section) => _buildSectionCard(section)).toList(),
        const SizedBox(height: 24),
        const SizedBox(height: 36),
      ],
    );
  }

  Widget _buildSectionCard(Map<String, dynamic> section) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
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
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    section['image'] as String,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        section['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          _buildInfoChip(
                            Icons.book,
                            '${section['lessons']} lessons',
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            Icons.access_time,
                            section['duration'] as String,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (section['completed'] as int) /
                            (section['lessons'] as int),
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${section['completed']}/${section['lessons']} completed',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
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
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Community Forum',
              style: TextStyle(
                fontSize: 20,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
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
    final currentUser = Author.users[0]; // Use the first user as current user
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
                radius: 16,
              ),
              const SizedBox(width: 10),
              Text(
                'Create Post',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
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
                    fillColor: theme.inputDecorationTheme.fillColor ?? theme.scaffoldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  style: TextStyle(color: colorScheme.onSurface),
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: theme.hintColor),
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor ?? theme.scaffoldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
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
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                    _createNewPost(titleController.text, descriptionController.text, currentUser, currentCommunity);
                    Navigator.pop(context);
                  }
                },
                child: Text(
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

  void _createNewPost(String title, String description, Author author, Community community) {
    final newPost = Post(
      title: title,
      description: description,
      voteCount: 0,
      upvote: 0,
      downVote: 0,
      author: author.name,
      avatar: author.avatar,
      time: 0, // Just posted
      commentCount: 0,
      communityName: community.name,
      communityImage: community.image,
    );

    setState(() {
      _posts.insert(0, newPost); // Add to the beginning to show newest first
    });
  }

  Widget _buildLeaderboardTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 24),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Top Contributors',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            _buildTimeFilterChip('Weekly', isActive: true),
            const SizedBox(width: 8),
            _buildTimeFilterChip('Monthly'),
            const SizedBox(width: 8),
            _buildTimeFilterChip('All Time'),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
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
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    const Text(
                      'Rank',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 24),
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
              const Divider(height: 1),
              ...List.generate(
                5,
                (index) => _buildTopMemberItem(
                  rank: index + 1,
                  name: _members[index].name,
                  username: _members[index].userName,
                  avatarUrl: _members[index].avatar,
                  points: _members[index].points,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Your Contribution',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
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
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.analytics,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Your Rank',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '27th out of 152 members',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '230 pts',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildStatItem('Posts', '5'),
                  _buildStatItem('Comments', '12'),
                  _buildStatItem('Likes', '43'),
                  _buildStatItem('Solutions', '2'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeFilterChip(String label, {bool isActive = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    
    return ChoiceChip(
      label: Text(label),
      selected: isActive,
      onSelected: (bool selected) {},
      backgroundColor: theme.colorScheme.surfaceVariant,
      selectedColor: colorScheme.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isActive ? colorScheme.primary : theme.colorScheme.onSurfaceVariant,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isActive ? colorScheme.primary : Colors.transparent,
        ),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
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
          const SizedBox(width: 24),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: themeExtension?.circleGradient,
            ),
            child: Center(
              child: Text(
                avatarUrl,
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
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
  
  Widget _buildStatItem(String label, String value) {
    final theme = Theme.of(context);
    
    return Column(
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildMembersTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'All Members',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
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
        const SizedBox(height: 24),
      ],
    );
  }

  // Add the _buildMemberAvatar method
  Widget _buildMemberAvatar(Author member) {
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: themeExtension?.circleGradient,
      ),
      child: CircleAvatar(
        radius: 22,
        backgroundImage: AssetImage(member.avatar),
      ),
    );
  }
}
