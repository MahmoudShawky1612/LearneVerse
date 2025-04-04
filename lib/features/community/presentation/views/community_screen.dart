import 'package:flutter/material.dart';

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
          style: const TextStyle(
            color: Colors.white,
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
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.community.memberCount} members',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    widget.community.communityPrivacy == "Public"
                        ? Icons.lock_open
                        : Icons.lock,
                    size: 16,
                    color: widget.community.communityPrivacy == "Public"
                        ? AppColors.upVote
                        : AppColors.downVote,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.community.communityPrivacy,
                    style: TextStyle(
                      color: widget.community.communityPrivacy == "Public"
                          ? AppColors.upVote
                          : AppColors.downVote,
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
                      color: Colors.grey[600],
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
          final isSelected = _currentIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey[300]!,
                ),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedScreen() {
    // If community is private and user hasn't joined, only show info screen
    if (widget.community.communityPrivacy == "Private" && !_userHasJoined) {
      return _buildPrivateCommunityMessage();
    }

    switch (_currentIndex) {
      case 0:
        return _buildInfoScreen();
      case 1:
        return _buildClassroomScreen();
      case 2:
        return _buildForumScreen();
      case 3:
        return _buildLeaderboardScreen();
      case 4:
        return _buildMembersScreen();
      default:
        return _buildInfoScreen();
    }
  }

  Widget _buildPrivateCommunityMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 40),
        Icon(
          Icons.lock,
          size: 80,
          color: AppColors.downVote.withOpacity(0.7),
        ),
        const SizedBox(height: 24),
        const Text(
          'Private Community',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'You need to join this community to access its content. Join now to interact with members and access all resources.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _userHasJoined = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                  padding: EdgeInsets.zero,
                  elevation: 6,
                  backgroundColor: Colors.transparent,
                  content: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: AppColors.buttonGradient,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.circleGradient,
                          ),
                          child: const Icon(
                            Icons.celebration,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Welcome aboard!",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "You're now part of ${widget.community.name}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ],
                    ),
                  ),
                  duration: const Duration(seconds: 5),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Join Community',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.backgroundLight,
              ),
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildInfoScreen() {
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
            color: Colors.grey[700],
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
              backgroundColor: AppColors.lightGrey,
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
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _userHasJoined = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    padding: EdgeInsets.zero,
                    elevation: 6,
                    backgroundColor: Colors.transparent,
                    content: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: AppColors.buttonGradient,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.circleGradient,
                            ),
                            child: const Icon(
                              Icons.celebration,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Welcome aboard!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "You're now part of ${widget.community.name}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                          ),
                        ],
                      ),
                    ),
                    duration: const Duration(seconds: 5),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Join Community',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.backgroundLight,
                ),
              ),
            ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            color: AppColors.primary,
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
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassroomScreen() {
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                        backgroundColor: Colors.grey[200],
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${section['completed']}/${section['lessons']} completed',
                        style: TextStyle(
                          color: Colors.grey[600],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            size: 14,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForumScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Community Forum',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('New Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
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

  Widget _buildLeaderboardScreen() {
    final List<Author> topMembers = _members.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 24),
        const Text(
          'Community Leaderboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildTopThreeMembers(topMembers.take(3).toList()),
        const SizedBox(height: 32),
        const Text(
          'Top Contributors',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...topMembers
            .skip(3)
            .take(7)
            .map((member) => _buildLeaderboardItem(
                  member,
                  topMembers.indexOf(member) + 1,
                ))
            .toList(),
        const SizedBox(height: 24),
        Center(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _currentIndex = 4; // Switch to Members tab
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('View All Members'),
          ),
        ),
        const SizedBox(height: 36),
      ],
    );
  }

  Widget _buildTopThreeMembers(List<Author> topThree) {
    final List<Widget> children = [];

    if (topThree.length > 1) {
      children.add(_buildTopMemberItem(second, 2, 100));
    }

    if (topThree.isNotEmpty) {
      children.add(_buildTopMemberItem(first, 1, 120));
    }

    if (topThree.length > 2) {
      children.add(_buildTopMemberItem(third, 3, 80));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: children,
    );
  }

  Widget _buildTopMemberItem(Author member, int position, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: <Widget>[
          Container(
            width: position == 1 ? 40 : 30,
            height: position == 1 ? 40 : 30,
            decoration: BoxDecoration(
              color: position == 1
                  ? Colors.amber
                  : position == 2
                      ? Colors.grey[400]
                      : Colors.brown[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$position',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 40),
                width: 80,
                height: height,
                decoration: BoxDecoration(
                  gradient: AppColors.circleGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage(member.avatar),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            member.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${member.points} points',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(Author member, int position) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: position <= 3
                  ? position == 1
                      ? Colors.amber
                      : position == 2
                          ? Colors.grey[400]
                          : Colors.brown[300]
                  : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$position',
                style: TextStyle(
                  color: position <= 3 ? Colors.white : Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(member.avatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  member.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  member.userName,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${member.points} pts',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersScreen() {
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
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${widget.community.memberCount} members',
                style: TextStyle(
                  color: Colors.grey[700],
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
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
              fillColor: Colors.grey[100],
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
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
}
